local OOP = require(script:FindFirstAncestor("OOP")) 
local Super = nil
local Layer = require(script.Parent.Layer)
local Input = require(script.Parent.Layer.Input)
local Activation = require(script.Parent.Activation)
local Initializer = require(script.Parent.Initializer)
local Cost = require(script.Parent.BaseClass.CostBase)
local MSE = require(script.Parent.Cost.MSE)
local Optimizer = require(script.Parent.BaseClass.OptimizerBase)
local Neuron = require(script.Parent.BaseClass.NeuronBase)

export type type = {
	network : {Layer.type},
	random : Random,
	cost : Cost.type,
	startLearningRate : number,
	seed : number,
	inputs : number,
	
	addLayer : (self : {}, layer : Layer.type) -> nil,
	feed : (self : {}, input : {number}) -> {number},
	createLayer : (self : {}, size : number, activation : Activation.type, optimizer : Optimizer.type) -> Layer.type,
	train : (self : {}, input : {number}, expected : {number}) -> nil,
	update : (self : {}) -> nil,
	test : (self : {}, batch : {}) -> string,
	toTable : (self : {}) -> {},
	loadTable : (self : {}, networkTable : {}) -> nil,
	clone : (self : {}) -> {},
	saveToDataStore : (self : {}, id : string) -> (boolean, {}),
	loadFromDataStore : (self : {}, id : string) -> boolean
} & Super.type

export type class = {new : (inputs : number, seed : number?) -> type}
local Class : class = OOP.class(script.Name, Super)

function Class.DeepNet(self : type, inputs : number, seed : number?)
	self.network = {}
	self.seed = seed or 42
	self.inputs = inputs
	self.random = Random.new(self.seed)
	self.cost = MSE.new()
	self.startLearningRate = 0
	table.insert(self.network, Input.new(self.inputs, self.random))
end

local function getLargestNeuron(output : {number})
	local max, maxi
	for i, v in ipairs(output) do
		if not max or max < v then
			max = v
			maxi = i
		end
	end
	return maxi
end

function Class.createLayer(self : type, size : number, activation : Activation.type, optimizer : Optimizer.type, bias : number?)
	return Layer.new(size, activation, optimizer, self.random, bias)
end

function Class.addLayer(self : type, layer : Layer.type, initializer : Initializer.type)
	table.insert(self.network, layer)
	local lastLayer = self.network[#self.network - 1]
	layer:connect(lastLayer, initializer)
end

function Class.feed(self : type, input : {number})
	local output = input
	for i, layer in ipairs(self.network) do
		output = layer:fire(output)
	end
	return output
end

function Class.train(self : type, batch : {})
	self:preBackprop()
	for b, currentBatch in ipairs(batch) do
		local input = currentBatch[1]
		local expected = currentBatch[2]
		local output = self:feed(input)
		local err = self.cost:getError(output, expected)
		self:backprop(err)
		self:generateDeltas(#batch)		
	end
	self:update()
end

function Class.test(self : type, batch : {})
	local amountCorrect = 0
	local total = #batch
	for b, currentBatch in ipairs(batch) do
		local input = currentBatch[1]
		local expected = currentBatch[2]
		local output = self:feed(input)	
		local outputNeuron = getLargestNeuron(output)
		local expectedNeuron = getLargestNeuron(expected)
		local correct = getLargestNeuron(expected) == getLargestNeuron(output)
		amountCorrect += correct and 1 or 0
	end
	return amountCorrect .. "/" .. total
end

function Class.trainOld(self : type, input : {number}, expected : {number})
	self:preBackprop()
	local output = self:feed(input)
	local err = self.cost:getError(output, expected)
	
	self:backprop(err)
	self:generateDeltas()		
	self:update()
end

function Class.preBackprop(self : type)
	for l, layer in ipairs(self.network) do
		if l ~= 1 then
			layer:preBackprop()
		end
	end
end

function Class.backprop(self : type, err : {number})
	local layerError = err
	for i = #self.network, 1, -1 do
		local layer : Layer.type = self.network[i]
		layerError = layer:backprop(layerError, self.network[i + 1])
	end
end

function Class.generateDeltas(self : type, batchSize : number)
	for l, layer in ipairs(self.network) do
		local pLayer : Layer.type = self.network[l - 1]
		layer:generateDeltas(pLayer, batchSize)
	end
end

function Class.update(self : type)
	for l, layer in ipairs(self.network) do
		if l ~= 1 then
			layer:update()
		end
	end
end

function Class.toTable(self : type)
	local networkTable = {}
	for l, layer in ipairs(self.network) do
		if l == 1 then
			continue
		end
		table.insert(networkTable, layer:toTable())
	end
	return networkTable
end

function Class.loadTable(self : type, networkTable : {})
	while (#self.network > 1) do
		table.remove(self.network, #self.network)
	end
	for l, layer in ipairs(networkTable) do
		local neurons = layer.neurons
		local activation = layer.activation
		local optimizer = layer.optimizer
		local learningRate = layer.learningRate or 0
		local loadLayer : Layer.type = self:createLayer(#neurons, require(script.Parent.Activation[activation]).new(), require(script.Parent.Optimizer[optimizer]).new(learningRate), 0)
		self:addLayer(loadLayer, require(script.Parent.Initializer.Range).new())
		for n, neuron in ipairs(layer.neurons) do
			local bias = neuron.bias
			local weights = neuron.weights
			local loadNeuron : Neuron.type = loadLayer.neurons[n]
			loadNeuron.bias = bias
			for w, weight in ipairs(weights) do
				loadNeuron.weights[w] = weight
			end
		end
	end
end

function Class.clone(self : type)
	local clone = Class.new(self.inputs, self.seed)
	local networkTable = self:toTable()
	clone:loadTable(networkTable)
	return clone
end

function Class.saveToDataStore(self : type, id : string)
	local DataStoreService = game:GetService("DataStoreService")
	local tbl = self:toTable()
	return pcall(function()
		local DataStore = DataStoreService:GetDataStore("MLuaSaves")
		DataStore:SetAsync(id, tbl)
	end)
end

function Class.loadFromDataStore(self : type, id : string)
	local DataStoreService = game:GetService("DataStoreService")
	local success, result = pcall(function()
		local DataStore = DataStoreService:GetDataStore("MLuaSaves")
		return DataStore:GetAsync(id)
	end)
	if success then
		self:loadTable(result)
	end
	return success
end

return Class
