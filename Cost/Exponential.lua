local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = require(script.Parent.Parent.BaseClass.CostBase)
export type type = {	
	gamma : number
} & Super.type
export type class = {new : (noparams : any) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.Exponential(self : type, gamma : number) 
	self.gamma = gamma or .9
end

function cost(self : type, output : {number}, expected : {number}) : number
	local totalCost = 0
	for i, v in ipairs(output) do
		totalCost += math.pow(output[i] - expected[i], 2)
	end
	totalCost = self.gamma * math.exp((1 / self.gamma) * totalCost)
	return totalCost
end

function Class.getError(self : type, output : {number}, expected : {number})
	Class.super(self)
	local cost = cost(self, output, expected)
	local err = {}
	for i, v in ipairs(output) do
		local errorValue = (2 / self.gamma) * (output[i] - expected[i]) * cost
		err[i] = errorValue
	end
	return err
end

return Class
