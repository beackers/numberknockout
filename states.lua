local M = {}

M.mid = nil

function M.setMid(mid)
  M.mid = mid
end

-- operations
local ops = {
  ["+"] = function(a,b) return a + b end,
  ["a-b"] = function(a,b) return a - b end,
  ["b-a"] = function(a,b) return b - a end,
  ["*"] = function(a,b) return a * b end,
  ["a/b"] = function(a,b) return (b ~= 0) and a / b or nil end,
  ["b/a"] = function(a,b) return (a ~= 0) and b / a or nil end
}

-- given numbers a, b, return all binary ops
function M.calc(a, b)
  local results = {}
  for op, func in pairs(ops) do
    results[#results+1] = func(a, b)
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
        if math.tointeger(r) then
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
  end

  return results
end

function M.canReach(state, min, max)
  local sum = 0
  for _, v in ipairs(state.raw) do
    sum = sum + math.abs(v)
  end
  return sum >= min and sum <= max
end

return M
