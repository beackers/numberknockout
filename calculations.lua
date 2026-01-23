local M = {}
function M.raws(a, b)
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
