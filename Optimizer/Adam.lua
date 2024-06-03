local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = require(script.Parent.Parent.BaseClass.OptimizerBase)
export type type = {
	squares : {},
	momentums : {},
	beta1 : number,
	beta2 : number
} & Super.type
export type class = {new : (params : any) -> type}
local Class : class = OOP.class(script.Name, Super)

local smallValue = math.pow(10, -8)

function Class.Adam(self : type, startingLearningRate : number)
	Class.super(self, startingLearningRate or 0)
	self.beta1 = .9
	self.beta2 = .999
	self.squares = {}
	self.momentums = {}
end

function Class.optimize(self : type, neuron, gradient : number, id : string)
	
	self.momentums[id] = self.momentums[id] or 0
	self.momentums[id] = self.momentums[id] * self.beta1
	self.momentums[id] += (1 - self.beta1) * gradient
	
	self.squares[id] = self.squares[id] or 0
	self.squares[id] = self.squares[id] * self.beta2
	self.squares[id] += (gradient * gradient) * (1 - self.beta2)
	
	local momentumHat = self.momentums[id] / (1 - self.beta1)
	local squareHat = self.squares[id] / (1 - self.beta2)

	local optimizedGradient = momentumHat * (self.learningRate / (math.sqrt(squareHat) + smallValue))
	
	return optimizedGradient
end

return Class
