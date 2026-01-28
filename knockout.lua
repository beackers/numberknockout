local states = require("states")

-- get numbers
if not (#arg > 2) then
  print("Not enough arguments: knockout needs at least 3 numbers. \nFirst number is bound minimum.\nSecond is bound max.\nAll numbers afterwards are the numbers to use.")
  os.exit()
end
local TARGET_MIN = math.tointeger(arg[1])
local TARGET_MAX = math.tointeger(arg[2])
local numbers = {}
for i = 3, #arg do
  numbers[#numbers + 1] = math.tointeger(arg[i])
end

states.setMid((TARGET_MAX + TARGET_MIN) / 2)

-- initialize min heap
local heap = require("min")

-- state one
local initial = states.newState(numbers, nil)
heap.push(initial)

results = {}
seen = {}

local state = nil

while not heap.isEmpty() do
  state = heap.pop()

  -- leaf case
  if #state.raw == 1 then
    results[state.raw[1]] = true
    goto continue
  end

  -- have we handled this?
  if seen[state.key] then
    goto continue
  end
  seen[state.key] = true

  for _, newState in ipairs(states.searchNextDepth(state)) do
    if states.canReach(newState, TARGET_MIN, TARGET_MAX) then
      heap.push(newState)
    end
  end

  ::continue::
end

-- sorting
local out = {}
for k in pairs(results) do
  out[#out + 1] = k
end
table.sort(out)

-- printing
for _, v in ipairs(out) do
  print(v)
end
