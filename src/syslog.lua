--
-- Simple logging client that sends data both to stdout and syslog
--

local log = {}

-- From RFC3164 - Simpler than RFC5424 and should still work
local USER = 1
local INFO = 6
local ERROR = 3

local MONTHS = {"", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}

local sock = net.createUDPSocket()
local pre_ip_buf = {}

local function do_log(severity, message)
   tm = rtctime.epoch2cal(rtctime.get())
   ts = string.format("%s %02d %02d:%02d:%02d", MONTHS[tm["mon"]], tm["day"], tm["hour"], tm["min"], tm["sec"])
   pri = USER * 8 + severity
   msg = string.format("<%d>%s %s %s", pri, ts, wifi.sta.gethostname(), message)
   print(msg)
   if wifi.sta.status() == wifi.STA_GOTIP then
      if pre_ip_buf then
         print("Catching up")
         for i, m in pairs(pre_ip_buf) do
            sock:send(514, RSYSLOG_IP, m)
         end
         pre_ip_buf = nil
      end
      print("Sending message to ", RSYSLOG_IP)
      sock:send(514, RSYSLOG_IP, msg)
   else
      table.insert(pre_ip_buf, msg)
   end
end


log.info = function(message)
   do_log(INFO, message)
end

log.error = function(message)
   do_log(ERROR, message)
end

return log
