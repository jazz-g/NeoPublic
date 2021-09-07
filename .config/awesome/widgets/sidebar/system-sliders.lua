local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local icons = require("icons")

--Icons
local brightnessIcon = wibox.widget{
	widget = wibox.widget.imagebox,
	forced_height = beautiful.dpi(40),
	resize = true,
}

local volumeIcon = wibox.widget{
	widget = wibox.widget.imagebox,
	forced_height = beautiful.dpi(40),
	resize = true,
}

-- Building of widgets
local volumeSlider = wibox.widget{
	bar_shape = gears.shape.rounded_rect,
	bar_height = beautiful.dpi(5),
	handle_shape = gears.shape.circle,
	handle_width = beautiful.dpi(15),
	handle_color = beautiful.straw,
	minimum = 0,
	maximum = 100,
	bar_active_color = beautiful.straw,
	widget = wibox.widget.slider,

}


local brightnessSlider = wibox.widget{
	bar_shape = gears.shape.rounded_rect,
	bar_height = beautiful.dpi(5), 
	handle_shape = gears.shape.circle,
	handle_width = beautiful.dpi(15),
	handle_color = beautiful.straw,
	minimum = 1, 
	maximum = 100,
	bar_active_color = beautiful.straw,
	widget = wibox.widget.slider,
}


local system_sliders = wibox.widget {
	{	
		{
			{
				{
					volumeIcon,
					widget = wibox.container.constraint,
					height = beautiful.height/27,
				},
				widget = wibox.container.place,
			},
			{
				volumeSlider,
				widget = wibox.container.margin,
				left = beautiful.width/128,
			},
			layout = wibox.layout.align.horizontal,
		},
		widget = wibox.container.margin,
		margins = beautiful.width/64,
	},
	{	
		{
			{
				{
					brightnessIcon,
					widget = wibox.container.constraint,
					height = beautiful.height/27,
				},
				widget = wibox.container.place,
			},
			{
				brightnessSlider,
				widget = wibox.container.margin,
				left = beautiful.width/128,
			},
			layout = wibox.layout.align.horizontal,
		},
		widget = wibox.container.margin,
		margins = beautiful.width/64,
	},
	layout = wibox.layout.ratio.vertical,
}

-- Called to switch the icons when the theme switches
-- Themes are opposite because these images are in foreground
function system_sliders.updateIcons()
	if beautiful.bg_normal == beautiful.choco then
		volumeIcon.image = icons.s.c.volume
		brightnessIcon.image = icons.s.c.brightness
	else
		volumeIcon.image = icons.s.v.volume
		brightnessIcon.image = icons.s.v.brightness
	end

end



-- Called on switch from vanilla to chocolate mode
function system_sliders.updateColors()
        volumeSlider.bar_color = beautiful.fg_normal
        brightnessSlider.bar_color = beautiful.fg_normal
end

-- Initially updates colors and connects theme switch signals
function system_sliders.setColorMode()
	system_sliders.updateColors()
	-- Connects signals to update bar + handle opacity settings if theme changes
        awesome.connect_signal("themeswitcher::chocolateswitch", system_sliders.updateColors)

        awesome.connect_signal("themeswitcher::vanillaswitch", system_sliders.updateColors)
end

-- Connects the signals for widget functionality
function system_sliders.init()
	system_sliders.setColorMode()
	system_sliders.updateIcons()
	volumeSlider:connect_signal("property::value", function(self, value)
		awful.spawn("pamixer --set-volume " .. value)
	end)
	brightnessSlider:connect_signal("property::value", function(self, value)
		awful.spawn("brightnessctl set " .. value .. "%")
	end)
	awesome.connect_signal("volume::up", function()
		volumeSlider.value = volumeSlider.value + 5
	end)
	awesome.connect_signal("volume::down", function()
		volumeSlider.value = volumeSlider.value - 5
	end)
	awesome.connect_signal("volume::mute", function()
		awful.spawn("pamixer -t")
		volumeSlider.mute = not volumeSlider.mute
		if volumeSlider.mute then
			volumeSlider.bar_active_color = beautiful.cherry
		else
			volumeSlider.bar_active_color = beautiful.straw
		end
	end)
	awesome.connect_signal("brightness::down", function()
		brightnessSlider.value = brightnessSlider.value - 5
	end)
	awesome.connect_signal("brightness::up", function()
		brightnessSlider.value = brightnessSlider.value + 5
	end)
	awful.widget.watch("pamixer --get-volume --get-mute", 5, function(widget, stdout, stderr, _, _)
		if string.match(stdout, "%a+") == "true" then
			widget.mute = true
			widget.bar_active_color = beautiful.cherry
		else
			widget.mute = false
			widget.bar_active_color = beautiful.straw
		end
		widget.value = tonumber(string.match(stdout, "%d+"))
	end, volumeSlider)

	awful.widget.watch("xbacklight -get", 5, function(widget, stdout, stderr, _, _)
		widget.value = tonumber(string.match(stdout, "%d+"))
	end, brightnessSlider)
end


return system_sliders
