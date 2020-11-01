require "math"

--- Calculate sunrise and sunset for a certain date and plate on Earth
-- See https://en.wikipedia.org/wiki/Sunrise_equation#Complete_calculation_on_Earth for
-- how to do this. The code here uses the same(ish) variable names as the Wikipedia page
-- to make things easier to follow.
--
-- The corresponding tests compare with Canada's National Research Council, which gives
-- every-so-slightly different results - on the order of a minute. I decided that for me,
-- that is good enough (see also the various definitions of "sunset").
-- @param lat The (decimal) latitude of the location
-- @param lng The (decimal) longitude ot the location
-- @param jd The Julian date timestamp indicating the day.
-- @return sun rise, solar noon, and sun set for the day in Julian time.
local sunrise_sunset = function(lat, lng, jd)
   local julian_date = math.floor(jd) -- note, by the way, that ".0" equals noon,
                                      -- not midnight, as the Julian date numbering
                                      -- started at 1200 somewhere in 4713 BC

   local n = julian_date - 2451545.0 + 0.0008 -- julian day
   local j_star = n - (lng / 360.0) -- mean solar noon
   local m = math.rad((357.5291 + 0.98560028 * j_star) % 360) -- solar mean anomaly
   local c = 1.9148 * math.sin(m) + 0.0200 * math.sin(2 * m) + 0.0003 * math.sin(3 * m) -- equation of the center
   local lambda = math.rad((math.deg(m) + c + 180 + 102.9372) % 360) -- ecliptic longitude
   local j_transit = 2451545.0 + j_star + 0.0053 * math.sin(m) - 0.0069 * math.sin(2 * lambda)
   local earth_tilt = math.rad(23.44)
   local delta = math.asin(math.sin(lambda) * math.sin(earth_tilt)) -- declination of the sun
   local correction_angle = math.rad(-0.83)
   local lat_rad = math.rad(lat)
   local omega_0_divident = math.sin(correction_angle) - math.sin(lat_rad) * math.sin(delta)
   local omega_0_divisor = math.cos(lat_rad) * math.cos(delta)
   local omega_0 = math.acos(omega_0_divident / omega_0_divisor) -- hour angle
   omega_0 = math.deg(omega_0)

   local j_rise = j_transit - (omega_0 / 360.0)
   local j_set = j_transit + (omega_0 / 360.0)

   return j_rise, j_transit, j_set
end

return sunrise_sunset
