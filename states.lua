local M = {}

M.mid = math.tointeger(arg[1])

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
  results = {}
  for op, func in pairs(ops) do
    results[#results+1] = func(a, b)
  end
  return results
end

function M.key(nums)
  local tmp = {}
  for i = 0, #nums do
    tmp[i] = nums[i]
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
end

function M.newState(nums)
  return {
    raw = nums,
    key = M.key(nums),
    score = M.scoreState(nums)
  }
end

function M.searchNextDepth(state)
  subresults = {}
  for i = 1, #state.raw - 1 do
    for j = i + 1, #state.raw do
      local a, b = state.raw[i], state.raw[j]
      for _, r in M.calc(a, b) do
        table.insert(subresults, r)
      end
      local results = {}
      for _, r in subresults do
        table.insert(results, M.newState(r))
      end
    end
  end
  return results
end

return M
