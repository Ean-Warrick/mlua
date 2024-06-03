local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = require(script.Parent.Parent.BaseClass.InitializerBase)
export type type = {} & Super.type
export type class = {new : (params : any) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.HeNormal(self : type) end

function Class.init(self : type, random : Random, lastLayerSize : number)
	return random:NextNumber() * (2 / lastLayerSize)
end

return Class
