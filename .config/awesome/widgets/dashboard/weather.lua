local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local watch = require("awful.widget.watch")
local icons = require("icons")

-- Uptime command
local get_weather_cmd = beautiful.homePath .. ".config/awesome/scripts/weather.py"

local ht = beautiful.height
local outerGapFact = beautiful.outerGapFact
local innerGapFact = beautiful.innerGapFact


local weather_status = wibox.widget {
	widget = wibox.widget.textbox,
	font = beautiful.widgetfont .. " Bold 22",
	align = "center",
	valign = "center",
}

local temp_high = wibox.widget {
	widget = wibox.widget.textbox,
	font = beautiful.widgetfont .. " 16",
	align = "center",
	valign = "center",
}

local temp_low = wibox.widget {
	widget = wibox.widget.textbox,
	font = beautiful.widgetfont .. " 16",
	align = "center",
	valign = "center",
}

local temp_now = wibox.widget {
	widget = wibox.widget.textbox,
	font = beautiful.widgetfont .. " 19",
	align = "center",
	valign = "center",
}


local weather_icon = wibox.widget {
	widget = wibox.widget.imagebox,
	image = "",
	align = "center",
	valign = "center",
	resize = true,
	forced_height = 0.8*(ht - (2*(ht/outerGapFact.h) + (ht/innerGapFact.h) + (ht/(540/253)))),
}

local weather_icon_container = wibox.widget {
	weather_icon,
	widget = wibox.container.place,
}

-- Creation of container widget
local widget_text_container = wibox.widget {
	layout = wibox.layout.flex.vertical,
	weather_status,
	temp_now,
	temp_low,
	temp_high,
	spacing = -25,
}

local weather_widget = wibox.widget{ 
	weather_icon_container,
	widget_text_container,
	layout = wibox.layout.flex.horizontal,
}


-- Updates the widget
local function update_widget(icon, status, tempN, tempL, tempH)
	temp_now.text = tempN .. "°C"
	temp_low.text = "Low of " .. tempL .. "°C"
	temp_high.text = "High of " .. tempH .. "°C"
	weather_status.text = status
	if icon == "thunder" then
		weather_icon.image = icons.w.thunder
	elseif icon == "rain" then
		weather_icon.image = icons.w.rainy
	elseif icon == "snow" then
		weather_icon.image = icons.w.snow
	elseif icon == "fog" then
		weather_icon.image = icons.w.fog
	elseif icon == "sun" then
		weather_icon.image = icons.w.sunny
	elseif icon == "cloudy_sun" then
		weather_icon.image = icons.w.partlycloudy
	elseif icon == "cloudy" then
		weather_icon.image = icons.w.cloudy
	else
		weather_icon.image = ""
	end
end

-- Refreshes Widget every 5 minutes
function weather_widget.init()
	watch(get_weather_cmd, 300, 
		function(widget, stdout, stderr, _, _)
		icon = string.sub(string.match(stdout, "|.+|") or "||", 2, -2) 
			status = string.sub(string.match(stdout, "%$.+%$") or "$$", 2, -2) 
			tempN = string.sub(string.match(stdout, "%?.+%?") or "??", 2, -2) 
			tempL = string.sub(string.match(stdout, "%%.+%%") or "%%", 2, -2) 
			tempH = string.sub(string.match(stdout, "&.+&") or "&&", 2, -2) 
			if icon == nil or status == nil or tempN == nil or tempH == nil then
		
			else
				update_widget(icon, status, tempN, tempL, tempH)
			end
		end,
		weather_widget)
end

return weather_widget
