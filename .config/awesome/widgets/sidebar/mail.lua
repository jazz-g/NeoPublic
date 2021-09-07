local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local watch = require("awful.widget.watch")

-- Uptime command
local get_mail_cmd = beautiful.homePath .. ".config/awesome/scripts/getMail.sh"

-- Creation of textbox widget
local widget_mail = wibox.widget {
	widget = wibox.widget.textbox,
	font = beautiful.widgetfont .. " Italic 17",
	align = "center",
	valign = "center",
}

-- Refreshes Widget every 5 minutes
function widget_mail.init()
	watch(get_mail_cmd, 300, 
		function(widget, stdout, stderr, _, _)
			widget.text = string.match(stdout, "[%w %p]+") or ""

		end,
		widget_mail)
end

return widget_mail

