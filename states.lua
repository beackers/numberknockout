local M = {}

M.mid = nil
M.minBound = nil
M.maxBound = nil

function M.setMid(mid)
  M.mid = mid
end

function M.setBounds(minBound, maxBound)
  M.minBound = minBound
  M.maxBound = maxBound
end

local function isInteger(value)
  return value ~= nil and math.tointeger(value) ~= nil
end

local function safePow(base, exp)
  if not isInteger(exp) then
    return nil
  end
  exp = math.tointeger(exp)
  if exp < 0 then
    return nil
  end
  if base == 0 and exp == 0 then
    return nil
  end
  return base ^ exp
end

-- operations
local ops = {
  ["+"] = function(a, b) return a + b end,
  ["a-b"] = function(a, b) return a - b end,
  ["b-a"] = function(a, b) return b - a end,
  ["*"] = function(a, b) return a * b end,
  ["a/b"] = function(a, b) return (b ~= 0 and a % b == 0) and a / b or nil end,
  ["b/a"] = function(a, b) return (a ~= 0 and b % a == 0) and b / a or nil end,
  ["a^b"] = function(a, b) return safePow(a, b) end,
  ["b^a"] = function(a, b) return safePow(b, a) end
}

-- given numbers a, b, return all binary ops
function M.calc(a, b)
  local results = {}
  local seen = {}
  for op, func in pairs(ops) do
    local result = func(a, b)
    if isInteger(result) then
      result = math.tointeger(result)
      if not seen[result] then
        seen[result] = true
        results[#results + 1] = result
      end
    end
  end
  return results
end

function M.key(nums)
  local tmp = {}
  for i = 1, #nums do
    tmp[i] = math.tointeger(nums[i])
  end
  table.sort(tmp)
  return table.concat(tmp, ",")
end

function M.scoreState(nums)
  local scores = {}
  for i = 1, #nums do
    scores[i] = math.abs(M.mid - nums[i])
  end
  local sum = 0
  for _, v in ipairs(scores) do
    sum = sum + v
  end
  return sum
end

function M.newState(nums, parent)
  parent = parent or { score = 0 }
  return {
    raw = nums,
    key = M.key(nums),
    score = M.scoreState(nums),
    rscore = parent.score - M.scoreState(nums),
    depth = parent.depth and parent.depth + 1 or 0
  }
end

function M.searchNextDepth(state)
  local results = {}

  local nums = state.raw
  local n = #nums

  for i = 1, n - 1 do
    for j = i + 1, n do
      local a, b = nums[i], nums[j]

      for _, r in ipairs(M.calc(a, b)) do
        local nextNums = {}

        for k = 1, n do
          if k ~= i and k ~= j then
            nextNums[#nextNums + 1] = nums[k]
          end
        end

        nextNums[#nextNums + 1] = r
        results[#results + 1] = M.newState(nextNums, state)
      end
    end
  end

  return results
end

function M.canReach(state, min, max)
  if min == nil or max == nil then
    return true
  end
  if min > max then
    return false
  end
  local sumAbs = 0
  for _, v in ipairs(state.raw) do
    sumAbs = sumAbs + math.abs(v)
  end
  local lower = -sumAbs
  local upper = sumAbs
  return not (max < lower or min > upper)
end

return M
