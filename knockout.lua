local calc = require("calculations")



-- get numbers
local TARGET_MIN = math.tointeger(arg[1])
local TARGET_MAX = math.tointeger(arg[2])
local numbers = {}

if not (#arg > 2) then
  print("Not enough arguments: knockout needs at least 3 numbers. \nFirst number is bound minimum.\nSecond is bound max.\nAll numbers afterwards are the numbers to use.")
  os.exit()
end
for i = 3, #arg do
  table.insert(numbers, {
    value = tonumber(arg[i]),
    history = tostring(arg[i])
  })
end

local results, stats = require("phase1", numbers, TARGET_MIN, TARGET_MAX)

-- sorting
local out = {}
for _, r in pairs(results) do
  out[#out+1] = r
end
table.sort(out, function(a, b)
  return a.value < b.value
end
)

-- uniquing
-- skipping because we set, not list, so everything's already unique

-- printing (under 100, history included)
if #out < 100 then
  for _, r in ipairs(out) do
    print(tostring(math.tointeger(calc.eval(r))), r.history)
  end
end

print("~~~~~ stats for nerds ~~~~~~~")
print("calls:", stats.calls)
print("raw calls to search():", stats.rawcalls)
print("leaves:", stats.leaves)
print("results:", #out)
for d = 1, #stats.depth do
  print("depth ", d, stats.depth[d] or 0, "pruned ", stats.pruned[d] or 0)
end
local count = 0
for _ in pairs(stats.uniqueStates) do count = count + 1 end
print("unique states:", count)
