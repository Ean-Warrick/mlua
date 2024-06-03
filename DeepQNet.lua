local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = nil
local Network = require(script.Parent.DeepNet)

export type type = {
	main : Network.type,
	replay : {},
	
	store : (self : {}, state : {number}, action : number, reward : number, nextState : {number}) -> nil,
	train : (self : {}) -> nil,
	getAction : (self : {}, state : {number}) -> number
} & Super.type
export type class = {new : (params : any) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.DeepQNet(self : type, inputs : number, seed : number?)
	self.main = Network.new(inputs, seed)
	self.replay = {}
end

function argMaxi(input)
	local max = nil
	local maxi = nil
	for i, v in ipairs(input) do
		if not max or v > max then
			max = v
			maxi = i
		end
	end
	
	return maxi
end

function argMax(input)
	local max = nil
	local maxi = nil
	for i, v in ipairs(input) do
		if not max or v > max then
			max = v
			maxi = i
		end
	end

	return max
end

function Class.getAction(self : type, state : {number}) 
	local output = self.main:feed(state)
	local action = argMaxi(output)
	return action
end

function Class.store(self : type, state, action, reward, nextState, isEndState)
	if isEndState == nil then isEndState = false end
	local fullStep = {state, action, reward, nextState, isEndState}
	table.insert(self.replay, fullStep)
end

function Class.train(self : type)
	local trainingBatch = {}
	for s, step in ipairs(self.replay) do
		local state = step[1]
		local action = step[2]
		local reward = step[3]
		local nextState = step[4]
		local isEndState = step[5]
		
		local nextStateOutput = self.main:feed(nextState)
		local maxValue = not isEndState and argMax(nextStateOutput) or reward
		local target = reward + (.9 * maxValue)
		local stateOutput = self.main:feed(state)
		stateOutput[action] = target
		
		local trainingStep = {state, stateOutput}
		table.insert(trainingBatch, trainingStep)
	end
	
	self.main:train(trainingBatch)
end

return Class
