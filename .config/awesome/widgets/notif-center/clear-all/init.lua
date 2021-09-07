local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local icons = require("icons")

local dpi = beautiful.dpi
local clickable_container = require('widgets.clickable-container')

--local config_dir = gears.filesystem.get_configuration_dir()
--local widget_icon_dir = config_dir .. 'widgets/notif-center/icons/'

local notifbox_core = require('widgets.notif-center.build-notifbox')
local reset_notifbox_layout = notifbox_core.reset_notifbox_layout

local clear_all_imagebox = wibox.widget {
	{
		image = icons.s.v.clear_all,
		resize = true,
		forced_height = dpi(40),
		forced_width = dpi(40),
		widget = wibox.widget.imagebox,
	},
	layout = wibox.layout.fixed.horizontal
}

local clear_all_button = wibox.widget {
	{
		clear_all_imagebox,
		margins = dpi(7),
		widget = wibox.container.margin
	},
	widget = clickable_container
}

clear_all_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				reset_notifbox_layout()
			end
		)
	)
)


gears.timer({timeout = 5, call_now = true, autostart = true, callback = function()
	if beautiful.bg_normal == beautiful.choco then
		clear_all_imagebox.children[1].image = icons.s.c.clear_all
	else
		clear_all_imagebox.children[1].image = icons.s.v.clear_all
	end
end})

awesome.connect_signal("themeswitcher::chocolateswitch", function()
	if beautiful.bg_normal == beautiful.choco then
		clear_all_imagebox.children[1].image = icons.s.c.clear_all
	else
		clear_all_imagebox.children[1].image = icons.s.v.clear_all
	end
end)

awesome.connect_signal("themeswitcher::vanillaswitch", function()
	if beautiful.bg_normal == beautiful.choco then
		clear_all_imagebox.children[1].image = icons.s.c.clear_all
	else
		clear_all_imagebox.children[1].image = icons.s.v.clear_all
	end
end)

local clear_all_button_wrapped = wibox.widget {
	nil,
	{
		clear_all_button,
		bg = beautiful.groups_bg, 
		shape = gears.shape.circle,
		widget = wibox.container.background
	},
	nil,
	expand = 'none',
	layout = wibox.layout.align.vertical
}

return clear_all_button_wrapped
