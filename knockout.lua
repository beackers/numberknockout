local calc = require("calculations")

-- statistics (for nerds)
local stats = {
  calls = 0,
  rawcalls = 0,
  pruned = 0,
  leaves = 0
}
stats.depth = {}
stats.uniqueStates = {}


-- get numbers
local numbers = {}

for i = 1, #arg do
  table.insert(numbers, {
    value = tonumber(arg[i]),
    exp = 1,
    history = {}
  })
end

-- normalize keys
local function normalize(number)
  return tostring(math.tointeger(number))
end

-- unique state id
local function numberKey(n)
  return tostring(n.value) .. "^" .. tostring(n.exp)
end

local function stateKey(numbers)
  local tmp = {}
  for i = 1, #numbers do
    tmp[#tmp+1] = numbers[i]
  end

  table.sort(tmp, function(a, b)
    if a.value ~= b.value then
      return a.value < b.value
    else
      return a.exp < b.exp
    end
  end)

  local parts = {}
  for i = 1, #tmp do
    parts[#parts+1] = "(" .. numberKey(tmp[i]) .. ")"
  end

  return table.concat(parts, ",")
end


-- calculations
local results = {}
local allowedExps = {0, 0.5, 1, 2}
local function search(numbers, depth)
  stats.rawcalls = stats.rawcalls + 1
  -- base case n=1
  local n = #numbers
  if n == 1 then
    stats.leaves = stats.leaves + 1
    results[calc.eval(numbers[1])] = true
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

      -- calculate with all operations
      for _, r in ipairs(calc.raws(a, b)) do
        -- if we like r, then
        if r and math.abs(math.floor(r)) == r and r ~= math.huge and r ~= -math.huge then
          -- copy numbers without i or j
          local next = {}
          for k = 1, n do
            if k ~= i and k ~= j then
              next[#next+1] = numbers[k]
            end
          end

          -- add r
          next[#next+1] = {
            value = r,
            exp = 1,
            history = {}
          }

          -- go to the next level in the search
          search(next, depth+1)
        end -- we like r if
      end -- for each value of r
    end -- j index end
  end -- i index end
end -- fn end

search(numbers)

-- sorting
local out = {}
for r in pairs(results) do
  out[#out+1] = r
end
table.sort(out, function(a, b)
  return a < b
end
)

-- uniquing
-- skipping because we set, not list, so everything's already unique

-- printing (under 100)
if #out < 100 then
  for _, r in ipairs(out) do
    print(
      r
    )
  end
end


print("~~~~~ stats for nerds ~~~~~~~")
print("calls:", stats.calls)
print("raw calls to search():", stats.rawcalls)
print("leaves:", stats.leaves)
for d = 1, #stats.depth do
  print("depth ", d, stats.depth[d] or 0)
end
local count = 0
for _ in pairs(stats.uniqueStates) do count = count + 1 end
print("unique states:", count)
