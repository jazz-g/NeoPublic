local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = beautiful.dpi

local notif_header = wibox.widget {
	{
		text   = 'Notification Center',
		font   =  beautiful.notification_font .. ' 16',
		align  = 'left',
		valign = 'center',
		widget = wibox.widget.textbox,
	},
	widget = wibox.container.margin,
	left = beautiful.dpi(15),
}


local notif_center = function(s)

	s.dont_disturb = require('widgets.notif-center.dont-disturb')
	s.clear_all = require('widgets.notif-center.clear-all')
	s.notifbox_layout = require('widgets.notif-center.build-notifbox').notifbox_layout

	return wibox.widget {
		expand = 'none',
		layout = wibox.layout.fixed.vertical,
		spacing = dpi(10),
		{
			expand = 'none',
			layout = wibox.layout.align.horizontal,
			notif_header,
			nil,
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(7),
				s.dont_disturb,
				s.clear_all
			},
		},
		s.notifbox_layout
	}
end

return notif_center
