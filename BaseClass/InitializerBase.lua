local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = nil
export type type = {
	init : (self : {}, random : Random, lastLayer : {})	-> number
} & Super.type
export type class = {new : (params : any) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.Initializer(self : type) end

function Class.init(self : type, random : Random, lastLayerSize : number)
	return (random:NextNumber() * 2) - 1
end

return Class
