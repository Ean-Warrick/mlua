<img src="https://github.com/user-attachments/assets/615dc354-c176-4d69-b919-38d47f64b6f7" width="350" />

## About
MLua is a neural network focused machine learning library for the Luau scripting language.

## Why Use MLua
Other machine learning libraries are either made private, lack features or have a steep learning curve.

MLua is fully public and aims to be beginner friendly while maintaining advanced features.

### Advantages Of MLua
- OOP: MLua is developed with object oriented programming in mind, reducing code and simplyfying usage
- Customizable: MLua networks accept a wide variety of parameters allowing developers flexibility with their networks
- Expandable: Need something MLua doesn't have? Mlua is modular, making the process of adding new classes and functionality easy

## Usage
```luau
math.randomseed(42) -- sets seed to reproduce results

local MLua = require(game.ReplicatedStorage.MLua)
local Sigmoid = MLua.activation.sigmoid
local Adam = MLua.optimizer.adam
local Initializer = MLua.initializer.range

-- create network
local network = MLua.DeepNet.new(2) -- number of inputs

-- create layers
local layer_1 = network:createLayer(2, Sigmoid.new(), Adam.new(.01))
local layer_2 = network:createLayer(2, Sigmoid.new(), Adam.new(.01))
local output = network:createLayer(2, Sigmoid.new(), Adam.new(.01))

-- add layers
network:addLayer(layer_1, Initializer.new(-1, 1))
network:addLayer(layer_2, Initializer.new(-1, 1))
network:addLayer(output, Initializer.new(-1, 1))

-- create training data
local training_batch = { 
  {{0,0}, {1,0}}, -- {input, expected_output}
  {{1,1}, {1,0}},
  {{1,0}, {0,1}},
  {{0,1}, {0,1}}
} 

-- log results before training
print("---[ Before Training ]---")
print(network:feed({0,0})) -- {0.6681410215223273, 0.2922554270564461}
print(network:feed({1,1})) -- {0.6747427187347756, 0.2848499419868049}
print(network:feed({1,0})) -- {0.6671484060648536, 0.2937650249830102}
print(network:feed({0,1})) -- {0.6754843438222481, 0.2836627296974654}
print("")


-- train network
for i = 1, 20000 do
  network:train(training_batch) -- train using the training data 20,000 times
end

-- log results after training
print("---[ After Training ]---")
print(network:feed({0,0})) -- {0.9725624736271125, 0.02743563251454923}
print(network:feed({1,1})) -- {0.9725624762038038, 0.02743562994586957}
print(network:feed({1,0})) -- {0.02743845106441539, 0.972563366679614}
print(network:feed({0,1})) -- {0.02743720851696361, 0.9725646129975744}

```
## Installation
1. Find MLua at creator store page link: https://create.roblox.com/store/asset/18865860169/MLua-v100
2. Click 'try in studio' button
3. Open Roblox Studio
4. Open Toolbox
5. Find MLua under 'My Models'
6. Click MLua to add it to your studio
