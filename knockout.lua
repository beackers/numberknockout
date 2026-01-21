local perms = require("permutations")
local calc = require("calculations")

-- get numbers
local numbers = {}

for i = 1, #arg do
  table.insert(numbers, tonumber(arg[i]))
end

-- operators
local opsSymbols = { "+", "-", "/", "*", "%"}


-- calculate given numbers and operators
function calculate(nums, operators)
  return
end


-- calculations
local results = {}

-- for each permutation of numbers
for _, n in ipairs(perms.permutations(numbers, #numbers)) do
  -- for each permutation of operators
  for _, o in ipairs(perms.permuteOps(opsSymbols, #numbers - 1)) do

    -- find parentheses orders and calculate
    local l = calc.left(n, o)
    local r = calc.right(n, o)
    if l ~= nil and l ~= math.huge and l~= -math.huge then
      table.insert(results, {
        value = l,
        numbers = n,
        operators = o,
        grouping = "left"
      })
    end
    if r ~= nil and r ~= math.huge and r ~= -math.huge then
      table.insert(results, {
        value = r,
        numbers = n,
        operators = o,
        grouping = "right"
      })
    end
  end
end

-- sorting
table.sort(results, function(a, b)
  return a.value < b.value
end)

-- uniquing
local EPS = 1e-9
local unique = {}
local last = nil
for _, r in ipairs(results) do
  if not last or math.abs(r.value - last) > EPS then
    table.insert(unique, r)
    last = r.value
  end
end
results = unique

-- printing
for _, r in ipairs(results) do
  print(
    r.grouping,
    table.concat(r.numbers, ", "),
    table.concat(r.operators, ", "),
    "=",
    string.format("%8.6f", r.value)
  )
end
