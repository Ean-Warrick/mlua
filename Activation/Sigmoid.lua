local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = require(script.Parent.Parent.BaseClass.ActivationBase)
export type type = {} & Super.type
export type class = {new : (params : any) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.Sigmoid(self : type)
	Class.super(self)
end

function Class.pass(self : type, input : {number})
	local output = {}
	for i, value in ipairs(input) do
		output[i] = 1 / (1 + math.exp(-value))
	end
	return output
end

function Class.slope(self : type, value : number)
	local sig = 1 / (1 + math.exp(-value))
	return sig * (1 - sig)
end

return Class
