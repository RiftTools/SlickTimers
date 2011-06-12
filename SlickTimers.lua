-- SlickTimers

local Libra = LibStub:GetLibrary('Libra-alpha', true)
if not Libra then
	print('SlickerTimers Dependancy Missing: [Libra]')
	return
end

local MainGUI    = SlickTimers_MainGUI
local OptionsGUI = SlickTimers_OptionsGUI

local TimerList = {}

SlickTimers_Config = {
	x = 500,
	y = 500,
	width = 220,
	hide_when_done = true
}

--
-- Add a timer
--
-- @param   String   name      Name of the timer, also the text to be displayed
-- @param   int      duration  Duration of the timer in seconds
local function AddTimer(name, duration)
	local timer_bar = Libra.UI.ProgressBar:Create(MainGUI.Timers)
	timer_bar.timer = Libra.Utils.Timer:Create(name, duration)
	timer_bar.max = duration
	timer_bar.text.left:SetText(name)
	table.insert(TimerList, timer_bar)
end

--
-- Refreshes the timer bars
--
local function Refresh()
	table.sort(TimerList, function (a, b)		 
	    return a.timer.remaining > b.timer.remaining
	end)
	
	local last_bar = MainGUI.Timers
	local timer_num = 0
	for i, bar in pairs(TimerList) do
		timer_num = timer_num + 1
		if i == 1 then
			bar:SetPoint('TOPLEFT', last_bar, 'TOPLEFT')
		else
			bar:SetPoint('TOPLEFT', last_bar, 'BOTTOMLEFT')
		end
		bar:SetWidth(MainGUI.background:GetWidth() - (MainGUI.border.size * 2))
		last_bar = bar
	end
	
	MainGUI:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', SlickTimers_Config.x, SlickTimers_Config.y)
	if not SlickTimers_Config.width then
		SlickTimers_Config.width = 220
	end	
	MainGUI:Resize(timer_num * last_bar:GetHeight(), SlickTimers_Config.width)
end

---------------------------------
-- MainGUI Functions
---------------------------------

--
-- Control Box 'Options' button Click event
--
function MainGUI.controlbox.options.Event:LeftDown()
	MainGUI:ShowSettings()
end

--
-- Control Box 'New' button Click event
--
function MainGUI.controlbox.new.Event:LeftDown()
	print('GUI Coming Soon - Add via command line:')
	print('/slicktimers add 60 My Custom Timer')
end

--
-- Updates then displays the OptionsGUI
--
function MainGUI:ShowSettings()	
	OptionsGUI.form.barwidth:SetValue(SlickTimers_Config.width)
	OptionsGUI.form.window_x:SetValue(SlickTimers_Config.x)
	OptionsGUI.form.window_y:SetValue(SlickTimers_Config.y)
	OptionsGUI.form.hide_when_done:Toggle(SlickTimers_Config.hide_when_done)
	OptionsGUI:Show()
end

---------------------------------
-- OptionsGUI Functions
---------------------------------
function OptionsGUI.form.bt_Save.Event:LeftDown()
	SlickTimers_Config.width = OptionsGUI.form.barwidth:GetValue()
	SlickTimers_Config.x = OptionsGUI.form.window_x:GetValue()
	SlickTimers_Config.y = OptionsGUI.form.window_y:GetValue()
	SlickTimers_Config.hide_when_done = OptionsGUI.form.hide_when_done:GetValue()
	Refresh()
end

--
-- This handles checking our timers
--
local function _RefreshService()
	for i, bar in pairs(TimerList) do
		if bar.timer.remaining <= 0 then
			if SlickTimers_Config.hide_when_done then
				table.remove(TimerList, i)
				bar:SetVisible(false)
			end
		else
			bar:SetValue(bar.timer.remaining)
		end
	end
	Refresh()
end


AddTimer('Welcome to SlickTimers', 3)

MainGUI:Show()

-- Register our service
table.insert(Event.System.Update.Begin, { _RefreshService, 'SlickTimers', 'TimerList' })

-- Register our slash command
local function SetPosition(args)
	local cmd = args:match("(%a+)")
	cmd = tostring(cmd)
	
	if cmd == 'width' then
		if not x then
			print("Example: /slicktimers width 220")
		end
		SlickTimers_Config.width = x
		
	elseif cmd == 'pos' then
		if x and y then
			SlickTimers_Config.x = x
			SlickTimers_Config.y = y
		else
			print("Example: /slicktimers pos 200 100")	
		end
	elseif cmd == 'add' then
		local cmd, duration = args:match("(%a+) (%d+)")
		cmd, duration, name = tostring(cmd), tonumber(duration)
		local name = args:match("%a+ %d+ (.*)")
		name = tostring(name)
		
		if duration and name then
			AddTimer(name, duration)
		else
			print("Add a Timer: /slicktimers add <duration> <name>")
			print("Example: /slicktimers add 60 My Custom Timer")
		end		
	end
end
table.insert(Command.Slash.Register("SlickTimers"), { SetPosition, "SlickTimers", 'config' })