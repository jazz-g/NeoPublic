local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local ht = beautiful.height
local wt = beautiful.width


local userPic = wibox.widget{
	image = beautiful.homePath .. ".config/awesome/icons/profile_pic.png",
	resize = true,
--	forced_height = (ht/(540/253)) - 0.2*(ht/(540/253)),
	widget = wibox.widget.imagebox,

}

local userName = wibox.widget{
		text = "u/Osiris834",
		font = beautiful.widgetfont .. " Regular 26",
		widget = wibox.widget.textbox,
		align = "center",
		valign = "center",
	}


local widget_userPicture = wibox.widget{
	{
		userPic,
		valign = "bottom",
		halign = "center",
		forced_height = (ht/(540/253)) - 0.2*(ht/(540/253)),
		widget = wibox.container.place,
	},
	{
		userName,
		widget = wibox.container.place,
		valign = "top",
		halign = "center",
	},
	layout = wibox.layout.fixed.vertical,
}

return widget_userPicture
