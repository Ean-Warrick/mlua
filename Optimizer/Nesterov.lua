local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = require(script.Parent.Parent.BaseClass.OptimizerBase)
export type type = {
	lastGradients : {},
	decay : number
} & Super.type
export type class = {new : (params : any) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.Nesterov(self : type, startingLearningRate : number, decay : number)
	Class.super(self, startingLearningRate)
	self.decay = decay or .9
	self.lastGradients = {}
end

function Class.preBackprop(self : type, neuron, id) 
	self.lastGradients[neuron] = self.lastGradients[neuron] or {}
	self.lastGradients[neuron][id] = self.lastGradients[neuron][id] or 0
	local momentum = self.lastGradients[neuron][id] * self.decay
	self.lastGradients[neuron][id] = momentum
	if typeof(id) ~= "number" then -- updating bias
		neuron:updateBias(momentum * self.learningRate)
	else -- updating weight
		neuron:updateWeight(id, momentum * self.learningRate)
	end
end

function Class.optimize(self : type, neuron, gradient : number, id : string)
	self.lastGradients[neuron] = self.lastGradients[neuron] or {}
	local lastGradients = self.lastGradients[neuron]
	local lastGrad = lastGradients[id] or 0
	local optimizedGradient = gradient
	self.lastGradients[neuron][id] += optimizedGradient
	return optimizedGradient * self.learningRate
end

return Class
