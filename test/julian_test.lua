require "lunit"
local posix2julian = require "posix2julian"

module("julian_test", lunit.testcase)

function test_conversion()
   -- Float compares are notoriously finicky, so we compare as strings
   expected = "2459155.1714699"
   found = ""..posix2julian(1604246815)
   assert_equal(expected, found)
end
