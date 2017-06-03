--[[
%% properties
??? value
%% weather
%% events
%% globals
--]]

local presenceSensorId = ???
local dimmerId = 237
local dayStart = 6
local dayEnd = 21
local dayBrightness = "99"
local nightBrightness = "5"

local startSource = fibaro:getSourceTrigger()
if
	tonumber(fibaro:getValue(presenceSensorId, "value")) > 0
	or startSource["type"] == "other"
then
	local hour = os.date("*t")["hour"]
	local brightness
	if hour > dayStart and hour < dayEnd then brightness = dayBrightness else brightness = nightBrightness end
	fibaro:call(dimmerId, "setValue", brightness)
end
