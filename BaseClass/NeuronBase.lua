local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = nil
local Activation = require(script.Parent.ActivationBase)
local Initializer = require(script.Parent.InitializerBase)
local Optimizer = require(script.Parent.OptimizerBase)
export type type = {
	sum : number,
	value : number,
	bias : number,
	biasDelta : number,
	weights : {number},
	random : Random,
	weightDeltas : {number},
	error : number,
	optimizer : Optimizer.type,
	
	connect : (self : {}, layer : {}) -> nil,
	fire : (self : {}, input : {number}) -> nil,
	setValue : (self : {}, value : number) -> nil,
	setError : (self : {}, err : number) -> nil,
	update : (self : {}) -> nil,
	generateDeltas : (self : {}, pLayer : neuronLayer) -> nil,
	updateWeight : (self : {}, w : number, delta : number) -> nil,
	updateBias : (self : {}, delta : number) -> nil
} & Super.type
export type class = {new : (params : any) -> type}
local Class : class = OOP.class(script.Name, Super)

type neuronLayer = {neurons : {type}}

function Class.Neuron(self : type, optimizer : Optimizer.type, seed : Random, bias : number)
	self.value = 0
	self.bias = bias
	self.biasDelta = 0
	self.sum = 0
	self.weights = {}
	self.weightDeltas = {}
	self.error = nil
	self.random = seed
	self.optimizer = optimizer
end

function Class.connect(self : type, layer : neuronLayer, initializer : Initializer.type)
	for i, neuron in ipairs(layer.neurons) do
		self.weights[i] = initializer:init(self.random, #layer.neurons)
		self.weightDeltas[i] = 0
	end
end

function Class.fire(self : type, input : {number})
	self.sum = 0
	for i, inputValue in ipairs(input) do
		local weight = self.weights[i]
		self.sum += (inputValue * weight)
	end
	self.sum += self.bias
	return self.sum
end

function Class.setValue(self : type, value : number)
	self.value = value
end

function Class.setError(self : type, err : number)
	self.error = err
end

function Class.preBackprop(self : type)
	for w, weight in ipairs(self.weights) do
		self.optimizer:preBackprop(self, w)
	end
	
	self.optimizer:preBackprop(self, self)
end

function Class.generateDeltas(self : type, activation : Activation.type, pLayer : neuronLayer, batchSize : number)
	local err = self.error
	local dsum = activation:slope(self.sum)
	for w, weight in ipairs(self.weights) do
		local pNeuron : Neuron.type = pLayer.neurons[w]
		local pValue = pNeuron.value
		local delta = pValue * dsum * err
		self.weightDeltas[w] += delta / batchSize
	end
	local biasDelta = err * dsum
	self.biasDelta += biasDelta / batchSize
end

function Class.update(self : type)
	for w, weight in ipairs(self.weights) do
		local delta = self.weightDeltas[w]
		local optimizedDelta = self.optimizer:optimize(self, delta, w) 
		self:updateWeight(w, optimizedDelta)
		self.weightDeltas[w] = 0
	end
	local optimizedBiasDelta = self.optimizer:optimize(self, self.biasDelta, self)
	self:updateBias(optimizedBiasDelta)
	self.biasDelta = 0
end

function Class.updateWeight(self : type, w : number, delta : number)
	self.weights[w] -= delta
end

function Class.updateBias(self : type, delta : number)
	self.bias -= delta
end

function Class.toTable(self : type)
	local neuronTable : type = {}
	neuronTable.weights = {}
	for w, weight in ipairs(self.weights) do
		neuronTable.weights[w] = weight
	end
	neuronTable.bias = self.bias
	return neuronTable
end

return Class
