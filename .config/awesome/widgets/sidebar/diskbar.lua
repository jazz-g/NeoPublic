local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local icons = require("icons")

local disk_bar = wibox.widget{
	max_value = 100,
	value = 50,
	min_value = 0,
	widget = wibox.widget.progressbar,
	shape = gears.shape.rounded_bar,
	bar_shape = gears.shape.rounded_bar,
	background_color = beautiful.fg_normal,
	border_width = 0,
	color = beautiful.straw,
}

local disk_icon = wibox.widget{
        widget = wibox.widget.imagebox,
        forced_height = beautiful.dpi(40),
        resize = true,
}


local disk_widget = wibox.widget{
	{
		{
			{
				disk_icon,
				widget = wibox.container.constraint,
				height = beautiful.height/27,
			},
			widget = wibox.container.place,
		},
		{
			{
				{
					{
						disk_bar,
						widget = wibox.container.constraint,
						height = beautiful.dpi(5),
					},
					layout = wibox.layout.fixed.vertical,
				},
				widget = wibox.container.place,
			},
			widget = wibox.container.margin,
			left = beautiful.width/128,
		},
		layout = wibox.layout.align.horizontal,
	},
	widget = wibox.container.margin,
	margins = beautiful.width/64,
}

-- look I know I could use some kind of table here but I'll just stick to vim shortcuts, thank you very much
function disk_widget.update()
	disk_bar.background_color = beautiful.fg_normal
	if beautiful.bg_normal == beautiful.choco then
		disk_icon.image = icons.s.c.disk
	else
		disk_icon.image = icons.s.v.disk
	end
end

function disk_widget.init()
	awful.widget.watch(beautiful.homePath .. ".config/awesome/scripts/getdisk.sh", 5, function(widget, stdout, stderr, _, _)
		out = stdout:gmatch("([^\n]+)")
		widget.value = tonumber(out(1))*100
		if widget.value >= 90 then
			widget.color = beautiful.cherry
		else
			widget.color = beautiful.straw
		end
	end, disk_bar)
	awesome.connect_signal("themeSwitcher::chocolateswitch", disk_widget.update)
	awesome.connect_signal("themeSwitcher::vanillaswitch", disk_widget.update)
	disk_widget.update()
end


return disk_widget
