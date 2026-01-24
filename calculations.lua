local M = {}
function M.eval(n)
  return n.value ^ n.exp
end
function M.raws(a, b)
  a, b = M.eval(a), M.eval(b)
  return {
    a + b,
    a * b,
    a - b,
    b - a,
    (b ~= 0) and a / b or nil,
    (a ~= 0) and b / a or nil
  }
end
return M
