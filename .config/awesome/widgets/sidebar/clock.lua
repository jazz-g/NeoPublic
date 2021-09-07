local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")


local clock = wibox.widget.textclock()
local cal = wibox.widget.textclock()
clock.format = "%H %M"
clock.font = beautiful.widgetfont .. " 75"
clock.align = "center"
clock.valign = "center"
cal.format = "%A,  %m/%d/%Y"
cal.font = beautiful.widgetfont .. " 23"
cal.align = "center"
cal.valign = "center"

local clock_cal = wibox.widget{
	{
		clock,
		widget = wibox.container.margin,
		top = beautiful.dpi(10),
	},
	cal,
	layout = wibox.layout.fixed.vertical,
}



return clock_cal
