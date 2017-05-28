--[[
%% properties
5 value
%% weather
%% events
%% globals
--]]

local motionSensorId = 5
local lightSensorId = 7
local dimmerId = 23
local counterName = "UpperStairsTimer"
local dayStart = 6
local dayEnd = 20
local dayBrightness = "49"
local nightBrightness = "9"

local illuminanceThreshold = 50
local maxBrightness = "99"
local startSource = fibaro:getSourceTrigger()
if
	(
		tonumber(fibaro:getValue(motionSensorId, "value")) > 0
		and tonumber(fibaro:getValue(lightSensorId, "value")) < illuminanceThreshold
		and fibaro:getValue(dimmerId, "value") ~= maxBrightness
	)
	or startSource["type"] == "other"
then
	local counter = tonumber(fibaro:getGlobalValue(counterName)) + 1
	fibaro:setGlobal(counterName, counter)
	if counter == 1 then
		local hour = os.date("*t")["hour"]
		local brightness
		if hour > dayStart and hour < dayEnd then brightness = dayBrightness else brightness = nightBrightness end
		fibaro:call(dimmerId, "setValue", brightness)
	end
	setTimeout(function()
		local counter = tonumber(fibaro:getGlobalValue(counterName)) - 1
		fibaro:setGlobal(counterName, counter)
		if counter == 0 and fibaro:getValue(dimmerId, "value") ~= maxBrightness then fibaro:call(dimmerId, "turnOff") end
	end, 80000)
end
