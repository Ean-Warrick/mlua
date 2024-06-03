local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = nil
export type type = {
	pass : (self : {}, input : {number}) -> {number},
	slope : (self : {}, value : number) -> number
} & Super.type
export type class = {new : (params : any) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.Activation(self : type) end

function Class.pass(self : type, input : {number})
	error("Must extend pass from Activation")
end

function Class.slope(self : type, value : number)
	error("Must extend slope from Activation")
end

return Class
