local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local icons = require("icons")

-- batt_bar is under wifi due to there being space here from flex layout
local batt_bar = require("widgets.sidebar.batterybar")

local airplane_mode = wibox.widget{
	widget = wibox.widget.textbox,
	font = beautiful.widgetfont .. " 17",
	align = "left",
	valign = "center",
	text = "Airplane Mode",
}

local airplane_toggle = wibox.widget{
	image = icons.s.v.switch_off,
	resize = true,
	widget = wibox.widget.imagebox,
	forced_width = beautiful.dpi(60),
}

local wifi_status = wibox.widget{
	widget = wibox.widget.imagebox,
	resize = true,
	forced_width = beautiful.dpi(50),
}

local wifi_name = wibox.widget{
	widget = wibox.widget.textbox,
	font = beautiful.widgetfont .. " 17",
	align = "right",
	valign = "center",
}

-- envelope for the widgets
local wifi_widget = wibox.widget {
	batt_bar,
	{
		{
			{
				{
					{
						{	
							wifi_status,
							top = beautiful.dpi(7),
							bottom = beautiful.dpi(7),
							widget = wibox.container.margin,
						},
						widget = wibox.container.constraint,
					},
					widget = wibox.container.place,
					valign = "center",
					fill_vertical = true,
				},
				layout = wibox.layout.fixed.horizontal,
			},
			nil,
			wifi_name,
			layout = wibox.layout.align.horizontal,
		},
		left = beautiful.width/64,
		right = beautiful.width/64,
		forced_height = beautiful.dpi(48),
		widget = wibox.container.margin,
	},
	{
		{
			airplane_mode,
			nil,
			{
				{
					{	
						airplane_toggle,
						top = beautiful.dpi(7),
						bottom = beautiful.dpi(7),
						widget = wibox.container.margin,
					},
					valign = "center",
					fill_vertical = true,
					widget = wibox.container.place,
				},	
				layout = wibox.layout.fixed.horizontal,
			},
			layout = wibox.layout.align.horizontal,
		},
		left = beautiful.width/64,
		right = beautiful.width/64,
		forced_height = beautiful.dpi(48),
		widget = wibox.container.margin,
	},
	layout = wibox.layout.fixed.vertical,
}

function wifi_status.updateC()
	s = wifi_status.strength
	--would be really nice if lua implemented a switch statement, but nooo
	if s == -1 then
		wifi_status.image = icons.s.c.wifi_offline
	elseif s == 0 then
		wifi_status.image = icons.s.c.wifi_none
	elseif s == 1 then
		wifi_status.image = icons.s.c.wifi_low
	elseif s == 2 then 
		wifi_status.image = icons.s.c.wifi_ok
	elseif s == 3 then
		wifi_status.image = icons.s.c.wifi_good
	elseif s == 4 then
		wifi_status.image = icons.s.c.wifi_full
	else
		wifi_status.image = icons.s.c.wifi_offline
	end
end

function wifi_status.updateV()
	s = wifi_status.strength
	--would be really nice if lua implemented a switch statement, but nooo
	if s == -1 then
		wifi_status.image = icons.s.v.wifi_offline
	elseif s == 0 then
		wifi_status.image = icons.s.v.wifi_none
	elseif s == 1 then
		wifi_status.image = icons.s.v.wifi_low
	elseif s == 2 then 
		wifi_status.image = icons.s.v.wifi_ok
	elseif s == 3 then
		wifi_status.image = icons.s.v.wifi_good
	elseif s == 4 then
		wifi_status.image = icons.s.v.wifi_full
	else
		wifi_status.image = icons.s.v.wifi_offline
	end
end

function updateWifiStatus()
	if beautiful.bg_normal == beautiful.choco then
		wifi_status.updateC()
	else
		wifi_status.updateV()
	end
end

function airplane_toggle.getMode()
	awful.spawn(beautiful.homePath .. ".config/awesome/scripts/getAirplane.sh", function(stdout, stderr, _, _)
		stdout = stdout:gsub("[\n\r]", "")
		if stdout == "enabled" then
			airplane_toggle.enabled = false
		else 
			airplane_toggle.enabled = true
		end
		airplane_toggle.update()
	end)
end

function airplane_toggle.update()
	if airplane_toggle.enabled then
		if beautiful.bg_normal == beautiful.choco then
			airplane_toggle.image = icons.s.c.switch_on
		else
			airplane_toggle.image = icons.s.v.switch_on
		end
	else
		if beautiful.bg_normal == beautiful.choco then
			airplane_toggle.image = icons.s.c.switch_off
		else
			airplane_toggle.image = icons.s.v.switch_off
		end
	end
end

function wifi_widget.init()
	batt_bar.init()
	awful.widget.watch(beautiful.homePath .. ".config/awesome/scripts/getSSID.sh", 300, function(widget, stdout, stderr, _, _)
		-- gets rid of all the enters and weird control keys
		widget.text = stdout:gsub("[\n\r]", "")

	end, wifi_name)
	awful.widget.watch(beautiful.homePath .. ".config/awesome/scripts/getWifiStrength.sh", 5, function(widget, stdout, stderr, _, _) 
		-- Number between 0 and 70
		strength = tonumber(stdout)
		if strength == nil then
			-- Offline
			widget.strength = -1
		elseif strength <= 5 then
			-- Zero Bars
			widget.strength = 0
		elseif strength < 28 then
			-- Low Signal
			widget.strength = 1
		elseif strength < 42 then	
			-- Okay Signal
			widget.strength = 2
		elseif strength < 56 then
			-- Good Signal
			widget.strength = 3
		elseif strength <= 70 then
			-- Excellent Signal
			widget.strength = 4
		else
			-- Error, offline?
			widget.strength = -1
		end 
		updateWifiStatus()
	end, wifi_status)
	awful.widget.watch(beautiful.homePath .. ".config/awesome/scripts/getAirplane.sh", 6, function(widget, stdout, stderr, _, _)
		stdout = stdout:gsub("[\n\r]", "")
		if stdout == "enabled" then
			widget.enabled = false
		else
			widget.enabled = true
		end
		widget.update()	
	end, airplane_toggle)
	awesome.connect_signal("themeswitcher::chocolateswitch", updateWifiStatus)
	awesome.connect_signal("themeswitcher::vanillaswitch", updateWifiStatus)
	awesome.connect_signal("themeswitcher::chocolateswitch", airplane_toggle.update)
	awesome.connect_signal("themeswitcher::vanillaswitch", airplane_toggle.update)

	-- airplane mode button functionality
	airplane_toggle:connect_signal("button::press", function()
		airplane_toggle.enabled = not airplane_toggle.enabled
		airplane_toggle.update()
		if airplane_toggle.enabled then
			awful.spawn("nmcli radio all off")
		else
			awful.spawn("nmcli radio all on")
		end
	end)
end

return wifi_widget
