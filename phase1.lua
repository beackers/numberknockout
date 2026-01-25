local calc = require("calculations")

local numbers = arg[1]
local TARGET_MIN = math.tointeger(arg[2])
local TARGET_MAX = math.tointeger(arg[3])
-- statistics (for nerds)
local stats = {
  calls = 0,
  rawcalls = 0,
  pruned = {},
  leaves = 0
}
stats.depth = {}
stats.uniqueStates = {}

local allowedExps = {0, 0.5, 1, 2}
local function normalize(n)
  if n.value == 1 then
    return { value = 1, history = "1" }
  end
  return n
end
local function normalizeState(set)
  local out = {}

  for i = 1, #set do
    out[i] = normalize(set[i])
  end
  return out
end

local function initialStates(nums)
  local states = {{}}

  for _, n in ipairs(nums) do
    local nextStates = {}
    for _, e in ipairs(allowedExps) do
      local v = n.value ^ e
      if v == v and v ~= math.huge and v ~= -math.huge then
        for _, s in ipairs(states) do
          local copy = {}
          for i = 1, #s do copy[i] = s[i] end
          copy[#copy+1] = {
            value = v,
            history = (e == 1)
              and n.history
              or string.format("(%s)^%s", n.history, e)
          }
          nextStates[#nextStates+1] = copy
        end
      end
    end
    states = nextStates
  end

  return states
end

-- unique state id
local function numberKey(n)
  return tostring(n.value)
end

local function stateKey(numbers)
  local tmp = {}
  for i = 1, #numbers do
    tmp[#tmp+1] = numbers[i]
  end

  table.sort(tmp, function(a, b)
    return a.value < b.value
  end)

  local parts = {}
  for i = 1, #tmp do
    parts[#parts+1] = "(" .. numberKey(tmp[i]) .. ")"
  end

  return table.concat(parts, ",")
end


-- calculations
local results = {}
local function search(numbers, depth)
  stats.rawcalls = stats.rawcalls + 1

  -- leaf case
  local n = #numbers
  if n == 1 then
    local v = calc.eval(numbers[1])
    if not results[v]
       or #numbers[1].history < #results[v].history then
      results[v] = numbers[1]
      stats.leaves = stats.leaves+1
    end
    return
  end

  -- have we seen this?
  local key = stateKey(numbers)
  if stats.uniqueStates[key] then
    stats.pruned[depth or 1] = (stats.pruned[depth or 1] or 0) + 1
    return
  end
  stats.uniqueStates[key] = true

  -- do we want to see this?
  local lo, hi = calc.stateBounds(numbers)

  if hi < TARGET_MIN or lo > TARGET_MAX then
    stats.pruned[depth or 1] = (stats.pruned[depth or 1] or 0) + 1
    return
  end

  -- housekeeping
  depth = depth or 1
  stats.depth[depth] = (stats.depth[depth] or 0) + 1
  stats.calls = stats.calls + 1

  -- for indices i and j where i < j,
  for i = 1, n - 1 do
    for j = i + 1, n do
      -- get a and b
      local a, b = numbers[i], numbers[j]
      -- run calculations with them
      for _, r in ipairs(calc.raws(a, b)) do
        local r2 = normalize(r)
        -- if we like a result, then replace items i and j with one item r2.
        if r2.value and r2.value == math.abs(math.floor(r2.value)) then
          local next = {}
          for k = 1, n do
            if k ~= i and k ~= j then
              next[#next+1] = numbers[k]
            end
          end
          next[#next+1] = r2
          search(next, depth + 1)
        end
      end
    end
  end
end
for _, s in ipairs(initialStates(numbers)) do
  search(s)
end
return results, stats
