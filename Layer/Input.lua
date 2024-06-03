local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = require(script.Parent.Parent.BaseClass.LayerBase)
export type type = {} & Super.type
export type class = {new : (params : any) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.Input(self : type, size : number, seed : Random)
	Class.super(self, size, nil, nil, seed, 0)
end

function Class.fire(self : type, input : {number}) 
	for n, neuron in ipairs(self.neurons) do
		local value = input[n]
		neuron.value = value
		neuron.sum = value
	end
	return input
end

return Class
