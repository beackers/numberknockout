local calc = require("calculations")

-- statistics (for nerds)
local stats = {
  calls = 0,
  pruned = 0,
  leaves = 0
}
stats.depth = {}
stats.uniqueStates = {}


-- get numbers
local numbers = {}

for i = 1, #arg do
  table.insert(numbers, tonumber(arg[i]))
end

-- normalize keys
local function normalize(number)
  return tostring(math.tointeger(number))
end

-- unique state
local function stateKey(numbers)
  local tmp = {}
  for i = 1, #numbers do
    tmp[#tmp+1] = normalize(numbers[i])
  end
  table.sort(tmp)
  return table.concat(tmp, ",")
end


-- calculations
local results = {}
local function search(numbers, depth)
  -- base case n=1
  local n = #numbers
  if n == 1 then
    stats.leaves = stats.leaves + 1
    results[numbers[1]] = true
    return
  end

  -- have we already calculated this?
  local key = stateKey(numbers)
  if stats.uniqueStates[key] then
    stats.pruned = stats.pruned + 1
    return
  end
  stats.uniqueStates[key] = true

  -- recursion tracking
  depth = depth or 1
  stats.depth[depth] = (stats.depth[depth] or 0) + 1
  stats.calls = stats.calls + 1
  stats.uniqueStates = stats.uniqueStates or {}

  -- for indices i < j
  for i = 1, n - 1 do
    for j = i + 1, n do
      local a, b = numbers[i], numbers[j]

      -- calculate everything possible
      for _, r in ipairs(calc.raws(a, b)) do
        if r and math.abs(math.floor(r)) == r and r ~= math.huge and r ~= -math.huge then
          -- copy numbers but replace i and j with r
          local next = {}
          for k = 1, n do
            if k ~= i and k ~= j then
              next[#next+1] = numbers[k]
            end
          end
          next[#next+1] = r
          search(next, depth+1)
        end
      end
    end
  end
end

search(numbers)

-- sorting
local out = {}
for r in pairs(results) do
  out[#out+1] = r
end
table.sort(out)

-- uniquing
-- skipping because we set, not list, so everything's already unique

-- printing
for _, r in ipairs(out) do
  print(
    r
  )
end


print("~~~~~ stats for nerds ~~~~~~~")
print("calls:", stats.calls)
print("leaves:", stats.leaves)
for d = 1, #stats.depth do
  print("depth ", d, stats.depth[d] or 0)
end
local count = 0
for _ in pairs(stats.uniqueStates) do count = count + 1 end
print("unique states:", count)
