local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")



local notif_center = require("widgets.notif-center.init")(screen[1])

-- Slidebar Wibox Setup
local slidebar = wibox({
	ontop = true,
	bg = beautiful.bg_normal,
	type = dock,
	-- controls whether the box is open or not
	open = false,
	shape = gears.shape.rectangle,
	widget = notif_center,
})



-- Function to let subwidgets know it's safe to appear
function slidebar.showSubWidgets()
	slidebar.widget.visible = true
end

-- Warns subwidgets to dissappear before they get squished
function slidebar.hideSubWidgets()
	slidebar.widget.visible = false
end


-- Skips animation to close sidebar
function slidebar.slam_shut()
	slidebar.hideSubWidgets()
	slidebar.width = 1
	slidebar.visible = false
	slidebar.open = false
end

-- Skips animation to open sidebar
function slidebar.slam_open()
	slidebar.width = slidebar.open_width
	slidebar.visible = true
	slidebar.open = true
	slidebar.showSubWidgets()
end


-- Slides open sidebar
function slidebar.slide_open()
	slidebar.visible = true
	timer = gears.timer.start_new(slidebar.timedelta, function()
		if slidebar.width == slidebar.open_width then
			-- Slidebar is open
			slidebar.open = true
			slidebar.showSubWidgets()
			return false
		elseif slidebar.open_width - slidebar.width <= slidebar.wdelta then
			-- terminate next loop
			slidebar.width = slidebar.open_width
			slidebar.x = slidebar.target_x
			return true
		else
			-- increment by wdelta and deincrement x
			slidebar.x = slidebar.x - slidebar.wdelta
			slidebar.width = slidebar.width + slidebar.wdelta
			return true
		end
	end)
end

-- Slides sidebar shut
function slidebar.slide_shut()
	slidebar.hideSubWidgets()
	timer = gears.timer.start_new(slidebar.timedelta, function()
		if slidebar.width == 1 then
			-- Slidebar is closed
			slidebar.open = false
			slidebar.visible = false
			return false
		elseif slidebar.width <= slidebar.wdelta then
			-- terminate next loop
			slidebar.width = 1
			slidebar.x = beautiful.width
			return true
		else
			-- deincrement by wdelta 
			slidebar.width = slidebar.width - slidebar.wdelta
			slidebar.x = slidebar.x + slidebar.wdelta
			return true
		end
	end)
end

-- Set up Slidebar
function slidebar.init(x, y, h, w, time_to_open)
	slidebar.x = beautiful.width
	slidebar.target_x = x - math.floor(w+0.5)
	slidebar.y = y
	slidebar.height = h
	slidebar.width = w	
	slidebar.open_width = math.floor(w+0.5) -- ran into issue of it never opening on screens with widths not divisible by 4 due to decimals
	slidebar.animation_time = time_to_open
	slidebar.timedelta = 1/beautiful.refresh_fps
	slidebar.wdelta = slidebar.open_width/(beautiful.refresh_fps*time_to_open)

	-- sets opacity based on what mode it is
	if beautiful.bg_normal == beautiful.vanil then
		slidebar.bg = beautiful.bg_normal .. "80"
	elseif beautiful.bg_normal == beautiful.choco then
		slidebar.bg = beautiful.bg_normal .. "cc"
	else 
		slidebar.bg = beautiful.bg_normal
	end

--	slidebar.widget.init()

	slidebar.slam_shut()
	
	-- Connects signals to update bg + fg + opacity settings
	awesome.connect_signal("themeswitcher::chocolateswitch", function()
		slidebar.bg = beautiful.bg_normal .. "cc"
		slidebar.fg = beautiful.fg_normal
	end)
	
	awesome.connect_signal("themeswitcher::vanillaswitch", function()
		slidebar.bg = beautiful.bg_normal .. "80"
		slidebar.fg = beautiful.fg_normal
	end)
	
end


return slidebar
