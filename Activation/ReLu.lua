local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = require(script.Parent.Parent.BaseClass.ActivationBase)
export type type = {} & Super.type
export type class = {new : (params : any) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.ReLu(self : type)
	Class.super(self)
end

function Class.pass(self : type, input : {number})
	local output = {}
	for i, value in ipairs(input) do
		output[i] = math.max(0, value)
	end
	return output
end

function Class.slope(self : type, value : number)
	return value > 0 and 1 or 0
end

return Class
