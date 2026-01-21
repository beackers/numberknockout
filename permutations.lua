local M = {}

function M.permutations(list, r)
  local results = {}
  local r = r or #list
  
  local function permute(current, remaining)
    if #current == r then
      table.insert(results, current)
      return
    end

    for i=1, #remaining do
      local next = {}
      for _, v in ipairs(current) do table.insert(next, v) end
      table.insert(next, remaining[i])

      local rest = {}
      for j = 1, #remaining do
        if j~=i then
          table.insert(rest, remaining[j])
        end
      end

      permute(next, rest)
    end
  end
  permute({}, list)
  return results
end

function M.permuteOps(operators, needed)
  if needed == 1 then
    local result = {}
    for _, op in ipairs(operators) do
      table.insert(result, {op})
    end
    return result
  end

  local smaller = M.permuteOps(operators, needed - 1)
  local result = {}

  for _, seq in ipairs(smaller) do
    for _, op in ipairs(operators) do
      local new = {}
      for _, v in ipairs(seq) do table.insert(new, v) end
      table.insert(new, op)
      table.insert(result, new)
    end
  end
  return result
end

return M
