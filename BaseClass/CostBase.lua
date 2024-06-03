local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = nil
export type type = {
	getError : (self : {}, output : {number}, expected : {number}) -> {number}
} & Super.type
export type class = {new : (noparams : any) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.Cost(self : type) end

function Class.getError(self : type, output : {number}, expected : {number})
	local err = {}
	for i, v in ipairs(output) do
		local errorValue = 2 * (output[i] - expected[i])
		err[i] = errorValue
	end
	return err
end

return Class
