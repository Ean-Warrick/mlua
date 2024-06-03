local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = require(script.Parent.Parent.BaseClass.OptimizerBase)
export type type = {} & Super.type
export type class = {new : (learningRate : number) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.Basic(self : type, startingLearningRate : number)
	Class.super(self, startingLearningRate)
end

function Class.optimize(self : type, neuron, gradient : number, id : string)
	return self.learningRate * gradient
end

return Class
