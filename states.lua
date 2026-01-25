local M = {}

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
function M.next(a, b)
  results = {}
  for op, func in pairs(ops) do
    result = {
      value = func(a.value, b.value),
      history = string.format("(%s) %s (%s)", a.history, tostring(op), b.history)
    }
    results[#results+1] = result
  end
  return results
end

return M
