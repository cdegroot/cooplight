require "lunit"
local sunrise_sunset = require "sunrise_sunset"
local posix2julian = require "posix2julian"

module("sun_times_test", lunit.testcase)

function test_sunrise_sunset()
   -- Toronto
   local lat = 43.740
   local lng = -79.370

   -- Somewhere on 1 Nov 2020
   -- According to https://nrc.canada.ca/en/research-development/products-services/software-applications/sun-calculator/:
   -- Sun rise: 6:54 LT / 11:54 UTC
   -- Solar noon: 12:01 LT / 17:01 UTC
   -- Sun set: 17:07 LT / 22:07 UTC
   local jd = posix2julian(1604250457)
   local rise, noon, set = sunrise_sunset(lat, lng, jd)
   assert_equal("2459154.9966005", ""..rise)
   assert_equal("2459155.2098313", ""..noon)
   assert_equal("2459155.4230621", ""..set)

   -- 1 Apr 2020
   -- Sun rise: 5:58 LT / 10:58 UTC
   -- Solar noon: 12:21 LT / 17:21 UTC
   -- Sun set: 18:45 LT / 23:45 UTC
   jd = 2459306
   rise, noon, set = sunrise_sunset(lat, lng, jd)
   assert_equal("2459305.9580914", ""..rise)
   assert_equal("2459306.2237932", ""..noon)
   assert_equal("2459306.489495", ""..set)

end
