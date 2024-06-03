local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = require(script.Parent.Parent.BaseClass.CostBase)
export type type = {	
} & Super.type
export type class = {new : (noparams : any) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.Hellinger(self : type) end

function Class.getError(self : type, output : {number}, expected : {number})
	Class.super(self)
	local err = {}
	for i, v in ipairs(output) do
		local errorValue = (math.sqrt(output[i]) - math.sqrt(expected[i])) / (math.sqrt(2) * math.sqrt(output[i]))
		err[i] = errorValue
	end
	return err
end

return Class
