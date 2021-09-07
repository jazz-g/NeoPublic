local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local icons = require("icons")
local gears = require("gears")

local notif_box = wibox({
	ontop = true,
	bg = beautiful.bg_normal,
	type = "notification",
	shape = gears.shape.rectangle,
	visible = false,
	vol_mode = true,
	width = beautiful.width/(192/35),
	height = beautiful.height/(108/35),
	x = beautiful.width/2 - ((1/2)*beautiful.width/(192/35)),
	y = beautiful.height/2 - ((1/2)*(beautiful.height/(108/35))),
})

local indicator_icon = wibox.widget{
	widget = wibox.widget.imagebox,
	resize = true,
	image = "",
}

local indicator_bar = wibox.widget{
	max_value = 100,
	value = 50,
	min_value = 0,
	widget = wibox.widget.progressbar,
	shape = gears.shape.rounded_bar,
	bar_shape = gears.shape.rounded_bar,
	background_color = beautiful.fg_normal,
	fixed_height = beautiful.dpi(7),
	border_width = 0,
	color = beautiful.straw,
}

local notif_envelope = wibox.widget{
	nil,
	{
		{
			indicator_icon,
			widget = wibox.container.margin,
			margins = beautiful.dpi(20),
		},
		widget = wibox.container.place,
		valign = "center",
		halign = "center",
	},
	{
		{
			indicator_bar,
			valign = "bottom",
			halign = "center",
			forced_height = beautiful.dpi(7),
			widget = wibox.container.place,
		},
		widget = wibox.container.margin,
		margins = beautiful.dpi(20),
	},
	layout = wibox.layout.align.vertical,
}

-- Switch box to volume and restart countdown
function notif_box.call_vol()
	notif_box.vol_mode = true
	indicator_icon.update()
	awful.spawn.easy_async("pamixer --get-volume --get-mute", function(stdout, stderr, _, _)
		if string.match(stdout, "%a+") == "true" then
                        indicator_bar.color = beautiful.cherry
                else
                        indicator_bar.color = beautiful.straw
                end
		indicator_bar.value = tonumber(string.match(stdout, "%d+"))
	end)
	notif_box.visible = true
	notif_box.countdown:again()
end

-- Switch box to brightness and restart countdown
function notif_box.call_br()
	notif_box.vol_mode = false
	indicator_icon.update()
	awful.spawn.easy_async("xbacklight -get", function(stdout, stderr, _, _)
		indicator_bar.color = beautiful.straw
		indicator_bar.value = tonumber(string.match(stdout, "%d+"))
	end)
	notif_box.visible = true
	notif_box.countdown:again()
end

-- updates the widget icon if it's on brightness or volume mode
function indicator_icon.update()
	if beautiful.bg_normal == beautiful.choco then
		if notif_box.vol_mode then
			indicator_icon.image = icons.s.c.volume
		else
			indicator_icon.image = icons.s.c.brightness
		end
	else
		if notif_box.vol_mode then
			indicator_icon.image = icons.s.v.volume
		else
			indicator_icon.image = icons.s.v.brightness
		end
	end
end

function notif_box.update()
	indicator_icon.update()
	indicator_bar.background_color = beautiful.fg_normal
	if beautiful.bg_normal == beautiful.choco then
		notif_box.bg = beautiful.transchoco
	else
		notif_box.bg = beautiful.transvanil
	end
end

function notif_box.init()
	notif_box.update()
	notif_box.widget = notif_envelope
	awesome.connect_signal("brightness::up", notif_box.call_br)
	awesome.connect_signal("brightness::down", notif_box.call_br)
	awesome.connect_signal("volume::up", notif_box.call_vol)
	awesome.connect_signal("volume::down", notif_box.call_vol)
	awesome.connect_signal("volume::mute", notif_box.call_vol)
	notif_box.countdown = gears.timer({
		timeout = 1.5,
		autostart = false,
		call_now = false,
		single_shot = false,
		callback = function()
			notif_box.visible = false
		end
})
end

return notif_box
