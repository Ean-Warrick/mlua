local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = nil

export type type = {
	learningRate : number,
	
	optimize : (self : {}, neuron : {}, gradient : number, id : string) -> number
} & Super.type
export type class = {new : (params : any) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.Optimizer(self : type, startingLearningRate : number)
	self.learningRate = startingLearningRate
end

function Class.preBackprop(self : type, neuron, id) end

function Class.optimize(self : type, neuron, gradient : number, id : string)
	return self.learningRate * gradient
end

return Class
