-- File that manages the dynamic vanilla/chocolate theme switch script

require("os")
local gears = require("gears")
local beautiful = require("beautiful")


-- calculates solar altuitude, solar azimuth for location
function sunposition()
	latitude = 0.0
	longitude = 0.0
	time = os.time()
	if type(time) == 'table' then
		time = os.time(time)
	end

	local date = os.date('*t', time)
	local timezone = (os.time(date) - os.time(os.date('!*t', time))) / 3600
	if date.isdst then
		timezone = timezone + 1
	end

	local utcdate = os.date('*t', time - timezone * 3600)
	local latrad = math.rad(latitude)
	local fd = (utcdate.hour + utcdate.min / 60 + utcdate.sec / 3600) / 24
	local g = (2 * math.pi / 365.25) * (utcdate.yday + fd)
	
	local d = math.rad(0.396372 - 22.91327 * math.cos(g) + 4.02543 * math.sin(g) - 0.387205 * math.cos(2 * g) + 0.051967 * math.sin(2 * g) - 0.154527 * math.cos(3 * g) + 0.084798 * math.sin(3 * g))
	
	local t = math.rad(0.004297 + 0.107029 * math.cos(g) - 1.837877 * math.sin(g) - 0.837378 * math.cos(2 * g) - 2.340475 * math.sin(2 * g))
	
	local sha = 2 * math.pi * (fd - 0.5) + t + math.rad(longitude)
	local sza = math.acos(math.sin(latrad) * math.sin(d) + math.cos(latrad) * math.cos(d) * math.cos(sha))
	
	local saa = math.acos((math.sin(d) - math.sin(latrad) * math.cos(sza)) / (math.cos(latrad) * math.sin(sza)))
	
	return 90 - math.deg(sza), math.deg(saa)
end


function updateTheme()
	-- Checks if it's in light mode
	if beautiful.bg_normal == beautiful.vanil then
		vanillamode = true
	else
		vanillamode = false
	end

	altitude, azimuth = sunposition()
	if altitude <= 2 then
		awful.spawn(os.getenv("HOME") .. "/.config/awesome/scripts/set_theme.sh chocolate")
		-- Refreshes awesome if mode has changed to chocolate mode
		beautiful.setChocoMode()
		awesome.emit_signal("themeswitcher::chocolateswitch")
	else
		awful.spawn(os.getenv("HOME") .. "/.config/awesome/scripts/set_theme.sh vanilla")
		-- Refreshes awesome if mode has changed to vanilla mode
		beautiful.setVanilMode()
		awesome.emit_signal("themeswitcher::vanillaswitch")
	end
end

local themeUpdater = gears.timer {
	autostart = true,
	timeout = 300,
	call_now = true,
	callback = updateTheme()
}

return themeUpdater
