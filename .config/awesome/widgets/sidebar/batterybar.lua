local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local icons = require("icons")
local naughty = require("naughty")

local batt_bar = wibox.widget{
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

local batt_icon = wibox.widget{
        widget = wibox.widget.imagebox,
        forced_height = beautiful.dpi(40),
        resize = true,
}


local batt_widget = wibox.widget{
	{
		{
			{
				batt_icon,
				widget = wibox.container.constraint,
				height = beautiful.height/27,
			},
			widget = wibox.container.place,
		},
		{
			{
				{
					{
						batt_bar,
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
function batt_widget.update()
	batt_bar.background_color = beautiful.fg_normal
	
	c = beautiful.bg_normal == beautiful.choco
	if batt_bar.status == "Full" then
		if c then
			batt_icon.image = icons.s.c.bat_full_c
		else
			batt_icon.image = icons.s.v.bat_full_c
		end
	elseif batt_bar.status == "Charging" then
		-- critical
		if batt_bar.value <= 10 then
				
			if c then
				batt_icon.image = icons.s.c.bat_empty_c
			else
				batt_icon.image = icons.s.v.bat_empty_c
			end
		-- warning
		elseif batt_bar.value <= 20 then
			if c then
				batt_icon.image = icons.s.c.bat_crit_c
			else
				batt_icon.image = icons.s.v.bat_crit_c
			end
		
		-- ok
		elseif batt_bar.value <= 40 then
			if c then
				batt_icon.image = icons.s.c.bat_low_c
			else
				batt_icon.image = icons.s.v.bat_low_c
			end
		
		-- medium
		elseif batt_bar.value <= 60 then
			if c then
				batt_icon.image = icons.s.c.bat_ok_c
			else
				batt_icon.image = icons.s.v.bat_ok_c
			end
		
		-- good
		elseif batt_bar.value <= 80 then
			if c then
				batt_icon.image = icons.s.c.bat_good_c
			else
				batt_icon.image = icons.s.v.bat_good_c
			end

		-- full
		elseif batt_bar.value <= 100 then
			if c then
				batt_icon.image = icons.s.c.bat_full_c
			else
				batt_icon.image = icons.s.v.bat_full_c
			end
		
		-- unknown
		else
			if c then
				batt_icon.image = icons.s.c.bat_missing
			else
				batt_icon.image = icons.s.v.bat_missing
			end
		end
			
	elseif batt_bar.status == "Discharging" or batt_bar.status == "Not Charging" or batt_bar.status == "Unknown" then
		-- critical
		if batt_bar.value <= 10 then
				
			if c then
				batt_icon.image = icons.s.c.bat_empty
			else
				batt_icon.image = icons.s.v.bat_empty
			end
		-- warning
		elseif batt_bar.value <= 20 then
			if c then
				batt_icon.image = icons.s.c.bat_crit
			else
				batt_icon.image = icons.s.v.bat_crit
			end
		
		-- ok
		elseif batt_bar.value <= 40 then
			if c then
				batt_icon.image = icons.s.c.bat_low
			else
				batt_icon.image = icons.s.v.bat_low
			end
		
		-- medium
		elseif batt_bar.value <= 60 then
			if c then
				batt_icon.image = icons.s.c.bat_ok
			else
				batt_icon.image = icons.s.v.bat_ok
			end
		
		-- good
		elseif batt_bar.value <= 80 then
			if c then
				batt_icon.image = icons.s.c.bat_good
			else
				batt_icon.image = icons.s.v.bat_good
			end

		-- full
		elseif batt_bar.value <= 100 then
			if c then
				batt_icon.image = icons.s.c.bat_full
			else
				batt_icon.image = icons.s.v.bat_full
			end
		
		-- unknown
		else
			if c then
				batt_icon.image = icons.s.c.bat_missing
			else
				batt_icon.image = icons.s.v.bat_missing
			end
		end
	else 
		if c then
			batt_icon.image = icons.s.c.bat_missing
		else
			batt_icon.image = icons.s.v.bat_missing
		end
	end
end

function batt_widget.init()
	awful.widget.watch(beautiful.homePath .. ".config/awesome/scripts/getBatt.sh", 5, function(widget, stdout, stderr, _, _)
		out = stdout:gmatch("([^\n]+)")
		widget.value = tonumber(out(1))
		widget.status = out(2)
		if widget.status == "Full" or widget.status == "Charging" then
			widget.color = beautiful.mint
		elseif widget.status == "Discharging" or widget.status == "Not Charging" or widget.status == "Unknown" then
			if widget.value <= 20 then
				widget.color = beautiful.cherry
			else
				widget.color = beautiful.straw
			end
		else
			widget.color = beautiful.cherry
		end
		batt_widget.update()
		if widget.value <= 20 and widget.value >= 5 and widget.batt_good == true then
				naughty.notify({title = "Warning!", text = "Battery is at " .. widget.value, preset = naughty.config.presets.critical})
				batt_good = false
			elseif batt_good == false then
				batt_good = false
			elseif value < 5 then 
				naughty.notify({title = "Critical Warning", text = "Battery is at critical percentage. Entering hibernation in 60 seconds.", preset = naughty.config.presets.critical})
				gears.timer({timeout = 60, call_now = false, autostart = true, single_shot = true, callback = function()
					awful.spawn(beautiful.homePath .. ".config/awesome/scripts/lock_screen.sh")
					awful.spawn("systemctl hibernate")
				end})
				
			elseif value > 20 then
				batt_good = true
			end
	end, batt_bar)
	awesome.connect_signal("themeSwitcher:chocolateswitch", batt_widget.update)
	awesome.connect_signal("themeSwitcher:vanillaswitch", batt_widget.update)
end


return batt_widget
