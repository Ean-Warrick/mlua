local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = require(script.Parent.Parent.BaseClass.OptimizerBase)
export type type = {
	squares : number,
} & Super.type
export type class = {new : (params : any) -> type}
local Class : class = OOP.class(script.Name, Super)
local smallValue = .0000000000001
function Class.Adagrad(self : type, startingLearningRate : number)
	Class.super(self, startingLearningRate)
	self.squares = {}
end

function Class.optimize(self : type, neuron, gradient : number, id : string)
	self.squares[id] = self.squares[id] or 0
	self.squares[id] += (gradient * gradient)
	return (self.learningRate / math.sqrt(self.squares[id])) * gradient
end

return Class
