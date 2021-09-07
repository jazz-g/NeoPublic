local os = require("os")

local path = os.getenv("HOME") .. "/.config/awesome/icons/"
local sb = path .. "sidebar/"
-- these are reversed because icons are in fg
local sbv = sb .. "chocolate/"
local sbc = sb .. "vanilla/"
local s = ".svg"
local p = ".png"
local we = path .. "weather/"

local icons = {
	-- sidebar icons
	s = {
	-- chocolate icons
	c = {
		volume 		= sbc .. "audio-volume-high" .. s,
		brightness 	= sbc .. "xfpm-brightness-lcd" .. s,
		
		airplane_mode	= sbc .. "airplane-mode" .. s,	
		wifi_full 	= sbc .. "network-wireless-signal-excellent" .. s,
		wifi_good 	= sbc .. "network-wireless-signal-good" .. s,
		wifi_ok 	= sbc .. "network-wireless-signal-ok" .. s,
		wifi_low 	= sbc .. "network-wireless-signal-low" .. s,
		wifi_none 	= sbc .. "network-wireless-signal-none" .. s,
		wifi_offline 	= sbc .. "network-wireless-offline" .. s,
		
		switch_off	= sbc .. "switch-off" .. s,
		switch_on	= sbc .. "switch-on" .. s,

		bat_full	= sbc .. "battery-full" .. s,
		bat_good	= sbc .. "battery-good" .. s,
		bat_ok		= sbc .. "battery-medium" .. s,
		bat_low		= sbc .. "battery-low" .. s,
		bat_crit	= sbc .. "battery-caution" .. s,
		bat_empty	= sbc .. "battery-empty" .. s,
		bat_full_c	= sbc .. "battery-full-charged" .. s,
		bat_good_c	= sbc .. "battery-good-charging" .. s,
		bat_ok_c	= sbc .. "battery-medium-charging" .. s,
		bat_low_c	= sbc .. "battery-low-charging" .. s,
		bat_crit_c	= sbc .. "battery-caution-charging" .. s,
		bat_empty_c	= sbc .. "battery-empty-charging" .. s,
		bat_missing	= sbc .. "battery-missing" .. s,

		cpu 		= sbc .. "cpu" .. s,
		ram		= sbc .. "ram" .. s,
		disk 		= sbc .. "disk" .. s,
		
		notif_on 	= sbc .. "notification-on" .. s,
		notif_off 	= sbc .. "notification-disabled" .. s,
		
		clear_all	= sbc .. "clear-all" .. s,
		clear_notif	= sbc .. "clear-notification" .. s,
		new_notif	= sbc .. "new-notification" .. s,		
	
		sbarChoco = sbc,
				
	},

	-- vanilla icons	
	v = {
		volume 		= sbv .. "audio-volume-high" .. s,
		brightness 	= sbv .. "xfpm-brightness-lcd" .. s,
		
		airplane_mode	= sbv .. "airplane-mode" .. s,	
		wifi_full 	= sbv .. "network-wireless-signal-excellent" .. s,
		wifi_good 	= sbv .. "network-wireless-signal-good" .. s,
		wifi_ok 	= sbv .. "network-wireless-signal-ok" .. s,
		wifi_low 	= sbv .. "network-wireless-signal-low" .. s,
		wifi_none 	= sbv .. "network-wireless-signal-none" .. s,
		wifi_offline 	= sbv .. "network-wireless-offline" .. s,
		
		switch_off	= sbv .. "switch-off" .. s,
		switch_on	= sbv .. "switch-on" .. s,
		
		bat_full	= sbv .. "battery-full" .. s,
		bat_good	= sbv .. "battery-good" .. s,
		bat_ok		= sbv .. "battery-medium" .. s,
		bat_low		= sbv .. "battery-low" .. s,
		bat_crit	= sbv .. "battery-caution" .. s,
		bat_empty	= sbv .. "battery-empty" .. s,
		bat_full_c	= sbv .. "battery-full-charged" .. s,
		bat_good_c	= sbv .. "battery-good-charging" .. s,
		bat_ok_c	= sbv .. "battery-medium-charging" .. s,
		bat_low_c	= sbv .. "battery-low-charging" .. s,
		bat_crit_c	= sbv .. "battery-caution-charging" .. s,
		bat_empty_c	= sbv .. "battery-empty-charging" .. s,
		bat_missing	= sbv .. "battery-missing" .. s,
		
		cpu 		= sbv .. "cpu" .. s,
		ram		= sbv .. "ram" .. s,
		disk 		= sbv .. "disk" .. s,
		
		notif_on 	= sbv .. "notification-on" .. s,
		notif_off 	= sbv .. "notification-disabled" .. s,
		
		clear_all	= sbv .. "clear-all" .. s,
		clear_notif	= sbv .. "clear-notification" .. s,
		new_notif 	= sbv .. "new-notification" .. s, 

		sbarVanil = sbv,
	},
	},
	
	-- Weather Icons
	w = {
		sunny		= we .. "weather-sunny" .. s,
		cloudy		= we .. "weather-cloudy" .. s,
		fog		= we .. "weather-fog" .. s,
		partlycloudy	= we .. "weather-partly-cloudy" .. s,
		rainy		= we .. "weather-rainy" .. s,
		snow		= we .. "weather-snow" .. s,
		thunder		= we .. "weather-thunder" .. s,
	},
	
	path = path,
}

return icons
