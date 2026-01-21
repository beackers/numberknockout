-- imports
local perms = require("permutations")
local calc = require("calculations")

-- testing
local reallylongtable = {}
for i = 1, 30 do
  table.insert(reallylongtable, i)
end

local result1 = perms.permutations({1,2,3}, 3)
local result2 = perms.permutations({'a', 'b', 'c', 'd', 'e'}, 4)

local result3 = calc.left({1, 2, 3}, {"+", "-"})
local result4 = calc.right({1, 2, 3}, {"+", "-"})

print("-- PERMUTATIONS FUNCTION --")
print(perms.permutations)
for _, p in ipairs(result1) do
  print(table.concat(p, ", "))
end
for _, p in ipairs(result2) do
  print(table.concat(p, ", "))
end
for _, p in ipairs(result3) do
  print(table.concat({p}, ", "))
end
for _, p in ipairs(result4) do
  print(table.concat({p}, ", "))
end

