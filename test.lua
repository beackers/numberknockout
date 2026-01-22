-- imports
local perms = require("permutations")
local calc = require("calculations")

function pretty(table)
  print(table.concat(table, ", "))
end

-- testing
local reallylongtable = {}
for i = 1, 30 do
  table.insert(reallylongtable, i)
end

local result1 = perms.permutations({1,2,3}, 3)
local result2 = perms.permutations({'a', 'b', 'c', 'd', 'e'}, 4)

local result3 = calc.calc({1, 2, 3}, {"+", "-"})
local result4 = calc.calc({1, 2, 3, 4}, {"+", "-", "*"})

print("-- PERMUTATIONS FUNCTION --")
print(perms.permutations)
pretty(result1)
pretty(result2)
pretty(result3)
pretty(result4)
