local M = {}

-- evaluate given number
function M.eval(n)
  return n.value
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
function M.raws(a, b)
  results = {}
  for op, func in pairs(ops) do
    result = {
      value = func(M.eval(a), M.eval(b)),
      history = string.format("(%s) %s (%s)", a.history, tostring(op), b.history)
    }
    results[#results+1] = result
  end
  return results
end

-- given state, evaluate max and min
function M.stateBounds(numbers)
  local lo, hi = 0, 0
  for _, n in ipairs(numbers) do
    lo = lo + n.value
    hi = hi + n.value
  end
  return lo, hi
end

return M
