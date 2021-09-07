local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local icons = require("icons")

local cpu_bar = wibox.widget{
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

local cpu_icon = wibox.widget{
        widget = wibox.widget.imagebox,
        forced_height = beautiful.dpi(40),
        resize = true,
}


local cpu_widget = wibox.widget{
	{
		{
			{
				cpu_icon,
				widget = wibox.container.constraint,
				height = beautiful.height/27,
			},
			widget = wibox.container.place,
		},
		{
			{
				{
					{
						cpu_bar,
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
function cpu_widget.update()
	cpu_bar.background_color = beautiful.fg_normal
	if beautiful.bg_normal == beautiful.choco then
		cpu_icon.image = icons.s.c.cpu
	else
		cpu_icon.image = icons.s.v.cpu
	end
end

function cpu_widget.init()
	awful.widget.watch(beautiful.homePath .. ".config/awesome/scripts/getcpu.sh", 5, function(widget, stdout, stderr, _, _)
		out = stdout:gmatch("([^\n]+)")
		widget.value = tonumber(out(1))
		if widget.value >= 90 then
			widget.color = beautiful.cherry
		else
			widget.color = beautiful.straw
		end
	end, cpu_bar)
	awesome.connect_signal("themeSwitcher::chocolateswitch", cpu_widget.update)
	awesome.connect_signal("themeSwitcher::vanillaswitch", cpu_widget.update)
	cpu_widget.update()
end


return cpu_widget
