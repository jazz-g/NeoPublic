local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local clock_cal = require("widgets.sidebar.clock")
local system_sliders = require("widgets.sidebar.system-sliders")
local wifi = require("widgets.sidebar.wifi")
local batt_bar = require("widgets.sidebar.batterybar")
local cpu_bar = require("widgets.sidebar.cpubar")
local ram_bar = require("widgets.sidebar.rambar")
local disk_bar = require("widgets.sidebar.diskbar")
local mail = require("widgets.sidebar.mail")

local bar = wibox.widget{
	-- clock and calendar widget
	clock_cal,
	system_sliders,
	wifi,
	{
		cpu_bar,
		ram_bar,
		disk_bar,
		layout = wibox.layout.fixed.vertical,
		spacing = beautiful.height/(-108/5),
	},
	mail,
	layout = wibox.layout.ratio.vertical,
}

function bar.init()
	system_sliders.init()
	wifi.init()
	batt_bar.init()
	cpu_bar.init()
	ram_bar.init()
	disk_bar.init()
	mail.init()
end

return bar
