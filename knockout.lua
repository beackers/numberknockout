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

-- unique state
local function stateKey(numbers)
  local tmp = {}
  for i = 1, #numbers do
    tmp[#tmp+1] = numbers[i]
  end
  table.sort(tmp)
  return table.concat(tmp, ",")
end


-- calculations
local function search(numbers, depth)
  -- recursion tracking
  depth = depth or 1
  stats.depth[depth] = (stats.depth[depth] or 0) + 1
  stats.calls = stats.calls + 1
  stats.uniqueStates = stats.uniqueStates or {}

  -- base case n=1
  local n = #numbers
  if n == 1 then
    stats.leaves = stats.leaves + 1
    return { numbers[1] }
  end

  -- have we already calculated this?
  local key = stateKey(numbers)
  if stats.uniqueStates[key] then
    stats.pruned = stats.pruned + 1
    return stats.uniqueStates[key]
  end

  -- start results out here
  local results = {}

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

          -- keep going with new numbers
          local subresults = search(next, depth + 1)

          -- compile results list
          for _, r in ipairs(subresults) do
            results[#results+1] = r
          end
        end
      end
    end
  end

  -- map state -> results
  -- if we see state X and get results A, B, C,
  -- if we see state X again, we know what we get
  stats.uniqueStates[key] = results
  return results
end

local results = search(numbers)

-- sorting
table.sort(results, function(a, b)
  return a < b
end)

-- uniquing
local EPS = 1e-9
local unique = {}
local last = nil
for _, r in ipairs(results) do
  if not last or math.abs(r - last) > EPS then
    table.insert(unique, r)
    last = r
  end
end
results = unique

-- printing
for _, r in ipairs(results) do
  print(
    r
  )
end
print("~~~~~ stats for nerds ~~~~~~~")
print("calls:", stats.calls)
print("pruned:", stats.pruned)
print("leaves:", stats.leaves)
for d = 1, #stats.depth do
  print("depth ", d, stats.depth[d] or 0)
end
local count = 0
for _ in pairs(stats.uniqueStates) do count = count + 1 end
print("unique states:", count)
