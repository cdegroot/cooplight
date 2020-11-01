local posix2julian = require "posix2julian"
local sunrise_sunset = require "sunrise_sunset"

print("Initializing CoopLight™ (v1.0)")

LAMP_ON_BEFORE_SUNSET = 1800
LAMP_OFF_AFTER_SUNSET = 3600

function gpios_on()
   -- We have to switches so that we can run more leds off small transistors
   gpio.write(1, gpio.HIGH)
   gpio.write(2, gpio.HIGH)
end
function gpios_off()
   gpio.write(1, gpio.LOW)
   gpio.write(2, gpio.LOW)
end

-- Sleep this many seconds and then turn the lamp on
function sleep_until_lamp_on(time_to_sleep)
   print("Sleeping for", time_to_sleep, "until lamp can go on")
   if not tmr.create():alarm(time_to_sleep * 1000, tmr.ALARM_SINGLE, function()
                                turn_lamp_on(LAMP_ON_BEFORE_SUNSET + LAMP_OFF_AFTER_SUNSET)
                            end)
   then
      print("ERROR Could not create timer until lamp on, rebooting.")
      node.restart()
   end
end

function turn_lamp_on(time_to_lamp_off)
   print("Turning lamp on for", time_to_lamp_off, "seconds")
   gpios_on()
   if not tmr.create():alarm(time_to_lamp_off * 1000, tmr.ALARM_SINGLE, function()
                                print("Lamp has been on enough, turning off")
                                gpios_off()
                                sleep_until_next_round()
                            end)
   then
      print("ERROR Could not create timer until lamp off, rebooting.")
      node.restart()
   end

end

function sleep_until_next_round()
   print("Sleeping for an hour...")
   if not tmr.create():alarm(3600 * 1000, tmr.ALARM_SINGLE, function()
                                print("Doing another round")
                                ntp_sync()
                            end)
   then
      print("ERROR Could not create timer until next round, rebooting.")
      node.restart()
   end
end

function ntp_callback(seconds, micros, server, info)
  -- local n = rtctime.get()
  print("Synchronized NTP with", server)
  print("Current POSIX time is", seconds)
  local jd = posix2julian(seconds)
  print("Current Julian time is", jd)
  local sunrise, noon, sunset = sunrise_sunset(LAT, LON, jd)
  local time_to_sunset = (sunset - jd) * 84600
  time_to_sunset = math.floor(time_to_sunset)
  print("Sunset in:", time_to_sunset, "secs")

  local time_to_dusk_lamp_on = time_to_sunset - LAMP_ON_BEFORE_SUNSET

  -- if we have time to the lamp on, sleep
  if time_to_dusk_lamp_on > 0 then
     -- for precision, we don't sleep more than 90 minutes. I have no clue how reliable
     -- the NodeMCU `tmr` is, this should help.
     if time_to_dusk_lamp_on > 5400 then
        sleep_until_next_round()
     else
        sleep_until_lamp_on(time_to_dusk_lamp_on)
     end
  else
    time_to_dusk_lamp_off = time_to_sunset + LAMP_OFF_AFTER_SUNSET
    -- if we are in the lamp on time, switch it on
    if time_to_dusk_lamp_off > 0 then
      turn_lamp_on(time_to_dusk_lamp_off)
    else
      sleep_until_next_round()
    end
  end
  print("NTP callback complete, actions scheduled")
end

function ntp_err_callback(error_code, error_msg)
  print("NTP ERROR!", error_code, error_msg)
  -- Not much we can do but restart the node. We try with a delay,
  -- but if that doesn't work we go for it right away
  if not tmr.create():alarm(5000, tmr.ALARM_SINGLE, function()
    node.restart()
  end)
  then
    node.restart()
  end
end

function ntp_sync()
   sntp.sync(nil, ntp_callback, ntp_err_callback, 0)
end

-- Start the above machinery
gpios_off()
ntp_sync()
