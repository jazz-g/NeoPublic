---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local awful = require("awful")
local gfs = require("gears.filesystem")

local os = require("os")

local themes_path = os.getenv("HOME") .. '/.config/awesome/neo/'

local theme = {}

local xrdb = xresources.get_current_theme()
theme.xrdb = xrdb

theme.homePath = os.getenv("HOME") .. '/'

-- MONITOR REFRESH RATE
theme.refresh_fps = 60


theme.widgetfont = "Cabin"

theme.font          = "Cabin Regular 10"


theme.darkchoco     = "#321509"
theme.choco         = theme.darkchoco
theme.milkchoco     = "#62301b"
theme.vanil         = "#e5dace"
theme.straw         = "#c46a6b"
theme.mint          = "#a1ab57"
theme.cherry        = "#aa2830"

-- translucent backgrounds
theme.transchoco = theme.choco .. "cc"
theme.transvanil = theme.vanil .. "80"

awful.screen.connect_for_each_screen(function(s)
    theme.width = s.geometry.width
    theme.height = s.geometry.height
end)

theme.outerGapFact = {w=12.8, h=7.2}
theme.innerGapFact = {w=48.0, h=27.0}


theme.bg_normal     = xrdb.background
theme.bg_focus      = xrdb.color0
theme.bg_urgent     = xrdb.color1
theme.bg_minimize   = xrdb.color8
theme.bg_systray    = xrdb.background

theme.fg_normal     = xrdb.foreground
theme.fg_focus      = xrdb.color7
theme.fg_urgent     = xrdb.foreground
theme.fg_minimize   = xrdb.color15


function theme.setChocoMode()
    theme.bg_normal     = xrdb.background
    theme.bg_focus      = xrdb.color0
    theme.bg_minimize   = xrdb.color8
    theme.bg_systray    = xrdb.background

    theme.fg_normal     = xrdb.foreground
    theme.fg_focus      = xrdb.color7
    theme.fg_minimize   = xrdb.color15


    -- Variables set for theming notifications:
    theme.notification_bg = theme.transchoco
    end

function theme.setVanilMode()
    theme.bg_normal     = xrdb.foreground
    theme.bg_focus      = xrdb.color7
    theme.bg_minimize   = xrdb.color15
    theme.bg_systray    = xrdb.color8

    theme.fg_normal     = xrdb.background
    theme.fg_focus      = xrdb.color0
    theme.fg_minimize   = xrdb.color8
    
    theme.notification_bg = theme.transvanil

end

theme.dpi = dpi
theme.useless_gap   = dpi(15)
theme.border_width  = dpi(0)
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = 0
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

theme.taglist_bg_focus = theme.straw
theme.taglist_bg_occupied = theme.milkchoco
theme.taglist_bg_empty = theme.vanil
theme.taglist_bg_urgent = theme.mint
theme.taglist_bg_volatile = theme.mint

theme.notification_border_width = 0
theme.notification_border_color = "#00000000"
theme.notification_font = "Cabin Regular 12"
theme.notification_font_bold = "Cabin Regular 13"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."submenu.png"
theme.menu_height = dpi(20)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."titlebar/maximized_focus_active.png"

theme.wallpaper = themes_path.."background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."layouts/fairhw.png"
theme.layout_fairv = themes_path.."layouts/fairvw.png"
theme.layout_floating  = themes_path.."layouts/floatingw.png"
theme.layout_magnifier = themes_path.."layouts/magnifierw.png"
theme.layout_max = themes_path.."layouts/maxw.png"
theme.layout_fullscreen = themes_path.."layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."layouts/tileleftw.png"
theme.layout_tile = themes_path.."layouts/tilew.png"
theme.layout_tiletop = themes_path.."layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."layouts/spiralw.png"
theme.layout_dwindle = themes_path.."layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."layouts/cornernww.png"
theme.layout_cornerne = themes_path.."layouts/cornernew.png"
theme.layout_cornersw = themes_path.."layouts/cornersww.png"
theme.layout_cornerse = themes_path.."layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
