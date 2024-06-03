local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = nil
local Neuron = require(script.Parent.NeuronBase)
local Activation = require(script.Parent.ActivationBase)
local Initializer = require(script.Parent.InitializerBase)
local Optimizer = require(script.Parent.OptimizerBase)

export type type = {
	neurons : {Neuron.type},
	activation : Activation.type,
	seed : Random,
	optimizer : Optimizer.type,
	size : number,
	
	
	fire : (self : {}, input : {number}) -> {number},
	connect : (self : {}, layer : {}) -> nil,
	setError : (self : type, err : {number}) -> nil,
	update : (self : {}) -> nil,
	setInitializer : (self : {}, initializer : Initializer.type) -> nil
} & Super.type

export type class = {new : (size : number) -> type}

local Class : class = OOP.class(script.Name, Super)

function Class.Layer(self : type, size, activation, optimizer : Optimizer.type, seed : Random, bias : number?)
	bias = bias or 0
	self.neurons = {}
	self.activation = activation
	self.optimizer = optimizer
	for i = 1, size do
		local layerNeuron = Neuron.new(self.optimizer, seed, bias)
		table.insert(self.neurons, layerNeuron)
	end
end

function Class.setInitializer(self : type, initializer : Initializer.type)
	self.initializer = initializer
end

function Class.connect(self : type, layer : type, initializer : Initializer.type)
	for n, neruon in ipairs(self.neurons) do
		neruon:connect(layer, initializer)
	end
end

function Class.fire(self : type, input : {number}) 
	local sums = {}
	for i, neuron in ipairs(self.neurons) do
		local sum = neuron:fire(input)
		table.insert(sums, sum)
	end
	
	local values = self.activation:pass(sums)
	
	for n, neuron in ipairs(self.neurons) do
		local neuronValue = values[n]
		neuron:setValue(neuronValue)
	end
	
	return values
end

function Class.setError(self : type, err : {number})
	for n, neuron in ipairs(self.neurons) do
		local neuronError = err[n]
		neuron:setError(neuronError)
	end
end

function Class.preBackprop(self : type)
	for n, neuron in ipairs(self.neurons) do
		neuron:preBackprop()
	end
end

function Class.backprop(self : type, err : {number}, fLayer : type?)
	local propError = {}
	if not fLayer then
		self:setError(err)
		propError = err
	else
		for n, neuron in ipairs(self.neurons) do
			local sumError = 0
			for fn, fneuron in ipairs(fLayer.neurons) do
				local ferror = fneuron.error
				local fdz = fLayer.activation:slope(fneuron.sum)
				local fw = fneuron.weights[n]
				sumError += (ferror * fdz * fw)
			end
			propError[n] = sumError
		end
		self:setError(propError)
	end
	
	return propError
end

function Class.generateDeltas(self : type, pLayer : type?, batchSize : number)
	if pLayer then
		for n, neuron in ipairs(self.neurons) do
			neuron:generateDeltas(self.activation, pLayer, batchSize)
		end
	end
end

function Class.update(self : type)
	for n, neuron in ipairs(self.neurons) do
		neuron:update()
	end
end

function Class.toTable(self : type)
	local layerTable : type = {}
	layerTable.neurons = {}
	for i, neuron in ipairs(self.neurons) do
		table.insert(layerTable.neurons, neuron:toTable())
	end
	layerTable.optimizer = self.optimizer.__name
	layerTable.learningRate = self.optimizer.learningRate
	layerTable.activation = self.activation.__name
	return layerTable
end

return Class
