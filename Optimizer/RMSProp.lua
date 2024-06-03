local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = require(script.Parent.Parent.BaseClass.OptimizerBase)
export type type = {
	squares : number,
	decay : number
} & Super.type
export type class = {new : (params : any) -> type}
local Class : class = OOP.class(script.Name, Super)

local smallValue = math.pow(10, -8)

function Class.RMSProp(self : type, startingLearningRate : number, decay : number)
	Class.super(self, startingLearningRate)
	self.decay = decay or .999
	self.squares = {}
end

function Class.optimize(self : type, neuron, gradient : number, id : string)
	self.squares[id] = self.squares[id] or 0
	self.squares[id] = self.squares[id] * self.decay
	self.squares[id] += (gradient * gradient) * (1 - self.decay)
	return (self.learningRate / (math.sqrt(self.squares[id]) + smallValue)) * gradient
end

return Class
