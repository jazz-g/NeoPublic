-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library


local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local theme = require("neo.theme")
local os = require("os")

home = os.getenv("HOME")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

function toggleTile()
	if awful.layout.get() == awful.layout.suit.floating then
		awful.layout.set(awful.layout.suit.tile)
		tile = false
	else
		awful.layout.set(awful.layout.suit.floating)
		tile = true
	end
end


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end




-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/" .. "neo/theme.lua")

-- Dynamic Light/Dark theme switcher based on if the sun is up or not
themeSwitcher = require("widgets.themeSwitcher")


-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
--    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
--    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

awful.spawn("picom")

-- Adds power button and lid lock in systemd for menu functionality
awful.spawn.easy_async_with_shell("if [[ $(pgrep systemd-inhibit) ]]; then echo \"Lock Already exists\"; else systemd-inhibit --what=handle-power-key:handle-suspend-key:handle-lid-switch --who=neo --why='for acpid handling of these events' --mode=block sleep infinity; fi")

awful.spawn.with_shell("if [[ $(pgrep redshift) ]]; then echo \"Redshift already running\"; else redshift -l ##.#####:##.##### -t 6500K:3500K; fi")

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()


-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )


local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- {{{ Dashboard
dashPict = require("widgets.dashboard.userpicture")
dashRss = require("widgets.dashboard.rss_feed")
dashRss.init()
dashTodo = require("widgets.dashboard.todo")
dashTodo.init()
dashWeather = require("widgets.dashboard.weather")
dashWeather.init()
-- }}}

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "", "", "", "", "", "", "", "", "", "" }, s, awful.layout.layouts[1])


    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
	layout = wibox.layout.flex.horizontal,
    }

    -- Create a tasklist widget
--    s.mytasklist = awful.widget.tasklist {
  --      screen  = s,
    --    filter  = awful.widget.tasklist.filter.currenttags,
      --  buttons = tasklist_buttons
 --   }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 7, type = "menu" })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.flex.horizontal,
        s.mytaglist, 
    }
	
	-- {{{ DASHBOARD
    	-- Factors for wibox spacing
	local outerGapFact = beautiful.outerGapFact
	local innerGapFact = beautiful.innerGapFact

	local ht = beautiful.height
	local wt = beautiful.width

	-- Table of dimensions for dashboard widgets
	wd = {
	--	xpos, ypos, h, w
	--	UserPicture
		userPic = {x = wt - ((wt/outerGapFact.w) + 2*(wt/innerGapFact.w) + 2*(wt/6.4) + (wt/(960/253))), y = (ht/outerGapFact.h) + (ht - (2*(ht/outerGapFact.h) + (ht/innerGapFact.h) + (ht/(540/253)))) + (ht/innerGapFact.h), w = wt/(960/253), h = ht/(540/253)},
	--	Weather
		weather = {x = wt - ((wt/outerGapFact.w) + 2*(wt/innerGapFact.w) + 2*(wt/6.4) + (wt/(960/253))), y = ht/outerGapFact.h, w = wt/(960/253), h = ht - (2*(ht/outerGapFact.h) + (ht/innerGapFact.h) + (ht/(540/253)))},
	--	Todo
		todo = {x = wt - ((wt/outerGapFact.w) + (wt/innerGapFact.w) + 2*(wt/6.4)), y = ht/outerGapFact.h, w = wt/6.4, h = ht-(2*(ht/outerGapFact.h))},
	--	RSS
		rss = {x = wt - ((wt/outerGapFact.w) + (wt/6.4)), y = ht/outerGapFact.h, w = wt/6.4, h = ht-(2*(ht/outerGapFact.h))}
		}

	local dashboardBoxShape = function(cr, width, height)
		gears.shape.rectangle(cr, width, height)
	end

	local makeDashboardBox = function(xval, yval, wval, hval)
		local box = wibox({
			--widget config
			x=xval,
			y=yval,
			width=wval,
			height=hval,
			align="center",
			valign="center",
			visible=false,
			shape=dashboardBoxShape,
			bg=beautiful.darkchoco,
			fg=beautiful.vanil})
		box.type = "dock"
		return box
	end

	dsbdWeather = makeDashboardBox(wd.weather.x, wd.weather.y, wd.weather.w, wd.weather.h)
	dsbdUserPic = makeDashboardBox(wd.userPic.x, wd.userPic.y, wd.userPic.w, wd.userPic.h)
	dsbdTodo = makeDashboardBox(wd.todo.x, wd.todo.y, wd.todo.w, wd.todo.h)
	dsbdRss = makeDashboardBox(wd.rss.x, wd.rss.y, wd.rss.w, wd.rss.h)

	dashboardVisible = false

	-- Filling Boxes with widgets
	dsbdTodo.widget = dashTodo
	dsbdWeather.widget = dashWeather
	dsbdRss.widget = dashRss
	dsbdUserPic.widget = dashPict

	--}}}
end)

-- }}}


-- SLIDEBAR {{{
local leftbar = require("widgets.sidebar")
slidebar = require("sidebar")
slidebar.init(leftbar, 0, beautiful.useless_gap, beautiful.height - 2*beautiful.useless_gap, 0.25*beautiful.width, 0.1)
-- NOTIFICATION CENTER
-- open with super c 
local notif_center = require("widgets.notif-center.sidebar")
notif_center.init(beautiful.width, beautiful.useless_gap, beautiful.height - 2*beautiful.useless_gap, 0.25*beautiful.width, 0.1)
-- }}}

-- Volume and brightness indicators
volBrightNotif = require("widgets.vol-bright-notifier")
volBrightNotif.init()


-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "p", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    --Volume Keys
    awful.key({}, "XF86AudioRaiseVolume", function()
	    awesome.emit_signal("volume::up") end),
    awful.key({}, "XF86AudioLowerVolume", function()
		awesome.emit_signal("volume::down") end),
    awful.key({}, "XF86AudioMute", function()
	    awesome.emit_signal("volume::mute") end),

    -- Take Screenshot
    awful.key({}, "Print", function()
	    awful.spawn.with_shell("image=$(scrot -e 'echo $n') && dunstify -a scrot -u low -i $image \"Screenshot Saved\"") end),

    -- Media Keys
    awful.key({}, "XF86AudioPrev", function()
            awful.spawn("mpc cdprev")
	    awesome.emit_signal("music::refresh") end),
    awful.key({}, "XF86AudioPlay", function()
            awful.spawn("mpc toggle")
	    awesome.emit_signal("music::refresh") end),
    awful.key({}, "XF86AudioNext", function()
            awful.spawn("mpc next")
	    awesome.emit_signal("music::refresh") end),

    -- Brightness Keys
    awful.key({}, "XF86MonBrightnessUp", function()
		awesome.emit_signal("brightness::up") end),

	awful.key({}, "XF86MonBrightnessDown", function()
		awesome.emit_signal("brightness::down") end),

	    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
		      {description = "increase master width factor", group = "layout"}),
	    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
		      {description = "decrease master width factor", group = "layout"}),
	    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
		      {description = "increase the number of master clients", group = "layout"}),
	    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
		      {description = "decrease the number of master clients", group = "layout"}),
	    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
		      {description = "increase the number of columns", group = "layout"}),
	    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
		      {description = "decrease the number of columns", group = "layout"}),
	    
	    awful.key({ modkey,           }, "space", toggleTile,
		      {description = "Toggle floating / tile", group = "layout"}),

	    awful.key({ modkey, "Control" }, "n",
		      function ()
			  local c = awful.client.restore()
			  -- Focus restored client
			  if c then
			    c:emit_signal(
				"request::activate", "key.unminimize", {raise = true}
			    )
			  end
		      end,
		      {description = "restore minimized", group = "client"}),

	    -- ROFI MENUS -------------------------------------------------------------------
	    awful.key({ modkey },            "d",     function () awful.spawn("rofi -theme 'menus/app-launcher.rasi' -show drun -no-lazy-grab") end,
		      {description = "Invoke Rofi", group = "launcher"}),
	    awful.key({modkey, "Shift" }, "space", function()
		    awful.spawn(home .. "/.config/awesome/scripts/rofi/rofi-awesome-layout") end, 
		      {description = "Rofi Layout Switcher", group = "launcher"}),
	    awful.key({modkey, "Shift" }, "s", function()
	    	awful.spawn(home .. "/.config/awesome/scripts/rofi/rofi-shutdown") end,
		    {description = "Rofi Shutdown Menu", group = "launcher"} ),

	    -- DASHBOARD --------------------------------------------------------------------
	    awful.key({ modkey }, "w", function() 
		if dashboardVisible then
			dashboardVisible = false

			dsbdUserPic.visible = false
			dsbdTodo.visible = false
			dsbdWeather.visible = false
			dsbdRss.visible = false
		elseif not dashboardVisible then
			dashboardVisible = true

			dsbdUserPic.visible = true
			dsbdTodo.visible = true
			dsbdWeather.visible = true
			dsbdRss.visible = true
		end

	    end, {description = "Toggle Dashboad", group = "launcher"}),
	    

	    -- LEFT SIDEBAR-----------------------------------------------------------------------
	    awful.key({ modkey }, "b", function()
		if slidebar.open then
			slidebar.slide_shut()
		elseif not slidebar.open then
			slidebar.slide_open()
		else
			slidebar.slam_shut()
		end
	    end, {description = "Toggle Slidebar", group = "launcher"}),
	
	    -- RIGHT SIDEBAR ----------------------------------------------------------------------
	
	    awful.key({ modkey }, "c", function()
		if notif_center.open then
			notif_center.slide_shut()
		elseif not notif_center.open then
			notif_center.slide_open()
		else
			notif_center.slam_shut()
		end
	    end),

	    ---------------------------------------------------------------------------------

	    awful.key({ modkey }, "x",
		      function ()
			  awful.prompt.run {
			    prompt       = "Run Lua code: ",
			    textbox      = awful.screen.focused().mypromptbox.widget,
			    exe_callback = awful.util.eval,
			    history_path = awful.util.get_cache_dir() .. "/history_eval"
			  }
		      end,
		      {description = "lua execute prompt", group = "awesome"}),
	    -- Menubar
	    awful.key({ modkey }, "p", function() menubar.show() end,
		      {description = "show the menubar", group = "launcher"})
	)

	clientkeys = gears.table.join(
	    awful.key({ modkey,           }, "f",
		function (c)
		    c.fullscreen = not c.fullscreen
		    c:raise()
		end,
		{description = "toggle fullscreen", group = "client"}),
	    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
		      {description = "close", group = "client"}),
	    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
		      {description = "toggle floating", group = "client"}),
	    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
		      {description = "move to master", group = "client"}),
	    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
		      {description = "move to screen", group = "client"}),
	    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
		      {description = "toggle keep on top", group = "client"}),
	    
	    awful.key({ modkey,           }, "m",
		function (c)
		    c.maximized = not c.maximized
		    c:raise()
		end ,
		{description = "(un)maximize", group = "client"}),
	    awful.key({ modkey, "Control" }, "m",
		function (c)
		    c.maximized_vertical = not c.maximized_vertical
		    c:raise()
		end ,
		{description = "(un)maximize vertically", group = "client"}),
	    awful.key({ modkey, "Shift"   }, "m",
		function (c)
		    c.maximized_horizontal = not c.maximized_horizontal
		    c:raise()
		end ,
		{description = "(un)maximize horizontally", group = "client"})
	)

	-- Bind all key numbers to tags.
	-- Be careful: we use keycodes to make it work on any keyboard layout.
	-- This should map on the top row of your keyboard, usually 1 to 9.
	for i = 1, 10 do
	    globalkeys = gears.table.join(globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9,
			  function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
				   tag:view_only()
				end
			  end,
			  {description = "view tag #"..i, group = "tag"}),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			  function ()
			      local screen = awful.screen.focused()
			      local tag = screen.tags[i]
			      if tag then
				 awful.tag.viewtoggle(tag)
			      end
			  end,
			  {description = "toggle tag #" .. i, group = "tag"}),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
			  function ()
			      if client.focus then
				  local tag = client.focus.screen.tags[i]
				  if tag then
				      client.focus:move_to_tag(tag)
				  end
			     end
			  end,
			  {description = "move focused client to tag #"..i, group = "tag"}),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
			  function ()
			      if client.focus then
				  local tag = client.focus.screen.tags[i]
				  if tag then
				      client.focus:toggle_tag(tag)
				  end
			      end
			  end,
			  {description = "toggle focused client on tag #" .. i, group = "tag"})
	    )
	end

	clientbuttons = gears.table.join(
	    awful.button({ }, 1, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
	    end),
	    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

gears.timer.start_new(10, function()
	collectgarbage("step", 20000) return true
end)
