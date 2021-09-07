local wibox = require('wibox')
local beautiful = require('beautiful')
local naughty = require('naughty')
local gears = require('gears')
local icons = require("icons")

local dpi = beautiful.dpi


local clickable_container = require('widgets.clickable-container')

local ui_noti_builder = {}

-- Notification icon container
ui_noti_builder.notifbox_icon = function(ico_image)
	local noti_icon = wibox.widget {
		{
			id = 'icon',
			resize = true,
			forced_height = dpi(40),
			forced_width = dpi(40),
			widget = wibox.widget.imagebox
		},
		layout = wibox.layout.fixed.horizontal
	}
	noti_icon.icon:set_image(ico_image)
	return noti_icon
end



-- Notification title container
ui_noti_builder.notifbox_title = function(title)
	return wibox.widget {
		markup = title,
		font   = beautiful.notification_font_bold,
		align  = 'left',
		valign = 'center',
		widget = wibox.widget.textbox
	}
end

-- Notification message container
ui_noti_builder.notifbox_message = function(msg)
	return wibox.widget {
		markup = msg,
		font   = beautiful.notification_font .. ' 11',
		align  = 'left',
		valign = 'center',
		widget = wibox.widget.textbox
	}
end

-- Notification app name container
ui_noti_builder.notifbox_appname = function(app)
	return wibox.widget {
		markup  = app,
		font   = beautiful.notification_font .. ' 12',
		align  = 'left',
		valign = 'center',
		widget = wibox.widget.textbox
	}
end

-- Notification actions container
ui_noti_builder.notifbox_actions = function(n)
	actions_template = wibox.widget {
		notification = n,
		base_layout = wibox.widget {
			spacing        = dpi(0),
			layout         = wibox.layout.flex.horizontal
		},
		widget_template = {
			{
				{
					{
						{
							id     = 'text_role',
							font   = beautiful.notification_font .. ' 10',
							widget = wibox.widget.textbox
						},
						widget = wibox.container.place
					},
					widget = clickable_container
				},
				bg                 = beautiful.groups_bg,
				shape              = gears.shape.rounded_rect,
				forced_height      = 30,
				widget             = wibox.container.background
			},
			margins = 4,
			widget  = wibox.container.margin
		},
		style = { underline_normal = false, underline_selected = true },
		widget = naughty.list.actions,
	}

	return actions_template
end


-- Notification dismiss button
ui_noti_builder.notifbox_dismiss = function()

    local dismiss_imagebox = wibox.widget {
        {
            id = 'dismiss_icon',
            image = icons.s.c.clear_notif,
            resize = true,
            forced_height = dpi(5),
            widget = wibox.widget.imagebox
        },
        layout = wibox.layout.fixed.horizontal
    }
    awesome.connect_signal("themeswitcher::chocolateswitch", function()
	dismiss_imagebox.children[1].image = icons.s.c.clear_notif
    end)
    awesome.connect_signal("themeswitcher::vanillaswitch", function()
	dismiss_imagebox.children[1].image = icons.s.v.clear_notif
    end) 

    if beautiful.bg_normal == beautiful.choco then
	dismiss_imagebox.children[1].image = icons.s.c.clear_notif
   else
	dismiss_imagebox.children[1].image = icons.s.v.clear_notif
   end

    local dismiss_button = wibox.widget {
    	{
    		dismiss_imagebox,
    		margins = dpi(5),
    		widget = wibox.container.margin
    	},
    	widget = clickable_container
    }

    local notifbox_dismiss = wibox.widget {
    	dismiss_button,
    	visible = false,
        bg = beautiful.groups_title_bg,
        shape = gears.shape.circle,
        widget = wibox.container.background
    }

    return notifbox_dismiss
end


return ui_noti_builder
