local states = require("states")

-- get numbers
local TARGET_MIN = math.tointeger(arg[1])
local TARGET_MAX = math.tointeger(arg[2])
local numbers = {}

if not (#arg > 2) then
  print("Not enough arguments: knockout needs at least 3 numbers. \nFirst number is bound minimum.\nSecond is bound max.\nAll numbers afterwards are the numbers to use.")
  os.exit()
end
for i = 3, #arg do
  numbers[i] = arg[i]
end
local initialState = states.newState(numbers)
