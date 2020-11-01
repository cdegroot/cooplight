
--- Converts posix timestamps to (fractional) Julian day numbers
-- Note that this is not a super precise approach taking into
-- account any leap seconds that the future might throw at us.
-- @param posix_timestamp The timestamp to convert
local posix2julian = function(posix_timestamp)
   return (posix_timestamp / 86400.0) + 2440587.5
end

return posix2julian
