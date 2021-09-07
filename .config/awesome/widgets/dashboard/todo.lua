local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local watch = require("awful.widget.watch")

-- Todo command
local get_todo_cmd = beautiful.homePath .. ".config/awesome/scripts/getTodo.sh"

local todo_list = wibox.widget {
		widget = wibox.widget.textbox,
		font = beautiful.widgetfont .. " 17",
		align = "center",
		valign = "center",
		text = "",
	}

-- Creation of textbox widget
local widget_todo  = wibox.widget {
	wibox.widget {
		widget = wibox.widget.textbox,
		font = beautiful.widgetfont .. " Bold 25",
		align = "center",
		valign = "center",
		text = "To Do:",
	},
	todo_list,
	layout = wibox.layout.fixed.vertical,
}

-- Refreshes Widget every minute
function widget_todo.init()
	watch(get_todo_cmd, 60,
		function(widget, stdout, stderr, _, _)
			widget.text = string.match(stdout, ".+") or ""

		end,
		todo_list)
end

return widget_todo

