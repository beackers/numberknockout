local M = {}

--[[
This is the calculations module.
Everything here happens given two things:
- a table of the current permutation of numbers
- a table of the current permutation of operators
In <left> and <right>, the assumption is that there are three numbers, and groups like

  (a opt1 b) opt2 c
  a opt1 (b opt2 c)

which should work given that most number knockouts have three numbers given.
]]

-- operators
local ops = {
  ["+"] = function(a, b) return a + b end,
  ["-"] = function(a, b) return a - b end,
  ["*"] = function(a, b) return a * b end,
  ["/"] = function(a, b) return a / b end,
  ["%"] = function(a, b) return a % b end
}

-- parentheses group lefter
function M.left(num, op)
  local ok, result = pcall(function()
    return ops[op[2]]((ops[op[1]](num[1], num[2])), num[3])
  end)
  if ok then
    return result
  end
  return nil
end

-- parentheses group righter
function M.right(num, op)
  local ok, result = pcall(function()
    return ops[op[1]](num[1], (ops[op[2]](num[2], num[3])))
  end)
  if ok then
    return result
  end
  return nil
end

-- TODO
-- main calculate function
function M.calc(numbers, operators)
  return
end

return M
