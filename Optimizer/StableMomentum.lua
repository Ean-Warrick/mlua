local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = require(script.Parent.Parent.BaseClass.OptimizerBase)
export type type = {
	lastGradients : {},
	decay : number
} & Super.type
export type class = {new : (params : any) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.StableMomentum(self : type, startingLearningRate : number, decay : number)
	Class.super(self, startingLearningRate)
	self.decay = decay or .9
	self.lastGradients = {}
end

function Class.optimize(self : type, neuron, gradient : number, id : string)
	self.lastGradients[neuron] = self.lastGradients[neuron] or {}
	local lastGradients = self.lastGradients[neuron]
	local lastGrad = lastGradients[id] or 0
	local optimizedGradient = ((lastGrad * self.decay) + ((1 - self.decay) * gradient)) 
	self.lastGradients[neuron][id] = optimizedGradient
	return optimizedGradient * self.learningRate
end

return Class
