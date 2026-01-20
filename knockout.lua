local perms = require("permutations")

-- get numbers
local numbers = {}

for i = 1, #arg do
  table.insert(numbers, tonumber(args[i]))
end

-- operators
local ops = {
  ["+"] = function(a, b) return a + b end,
  ["-"] = function(a, b) return a - b end,
  ["*"] = function(a, b) return a * b end,
  ["/"] = function(a, b) return a / b end,
  ["%"] = function(a, b) return a % b end
}


-- calculations
local results = {}

-- for each permutation of numbers
for _, n in ipairs(perms.permutations(numbers, #numbers)) do
  -- for each permutation of operators
  for _, o in ipairs(perms.permutations(ops, #numbers - 1)) do
    -- now that we have an order of numbers (n)
    -- and an order of operators (o)
    -- find parentheses orders and calculate
    local result = perms.calculate(n, o)
    table.insert(results, result)
  end
end

-- print things here
