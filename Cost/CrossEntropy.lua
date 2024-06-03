local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = require(script.Parent.Parent.BaseClass.CostBase)
export type type = {} & Super.type
export type class = {new : (noparams : any) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.CrossEntropy(self : type) end

function Class.getError(self : type, output : {number}, expected : {number})
	Class.super(self)
	local err = {}
	for i, v in ipairs(output) do
		local errorValue = (output[i] - expected[i]) / ((1 - output[i]) * output[i])
		err[i] = errorValue
	end
	return err
end

return Class
