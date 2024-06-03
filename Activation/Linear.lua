local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = require(script.Parent.Parent.BaseClass.ActivationBase)
export type type = {} & Super.type
export type class = {new : (params : any) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.Linear(self : type)
	Class.super(self)
end

function Class.pass(self : type, input : {number})
	return input
end

function Class.slope(self : type, value : number)
	return 1
end

return Class
