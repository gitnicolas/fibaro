--[[
%% properties
5 value
7 value
%% weather
%% events
%% globals
--]]

local counterName = "UpperStairsTimer"
local dayBrightness = "49"
local nightBrightness = "9"

local illuminanceThreshold = 900
local maxBrightness = "99"
local startSource = fibaro:getSourceTrigger()
if
	(
		tonumber(fibaro:getValue(5, "value")) > 0
		and tonumber(fibaro:getValue(7, "value")) < illuminanceThreshold
		and fibaro:getValue(23, "value") ~= maxBrightness
	)
	or startSource["type"] == "other"
then
	local counter = tonumber(fibaro:getGlobalValue(counterName)) + 1
	fibaro:setGlobal(counterName, counter)
	if counter == 1 then
		local brightness = nightBrightness
		fibaro:call(23, "setValue", brightness)
	end
	setTimeout(function()
		local counter = tonumber(fibaro:getGlobalValue(counterName)) - 1
		fibaro:setGlobal(counterName, counter)
		if counter == 0 and fibaro:getValue(23, "value") ~= maxBrightness then fibaro:call(23, "turnOff") end
	end, 80000)
end
