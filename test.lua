-- imports
local perms = require("permutations")

-- testing
local results = perms.permutations({1,2,3}, 3)

print("-- PERMUTATIONS FUNCTION --")
print(perms.permutations)
print("Table for permuations({1,2,3}, 3):")
for _, p in ipairs(results) do
  print(table.concat(p, ", "))
end
