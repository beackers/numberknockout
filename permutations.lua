local M = {}

function M.permutations(list, r)
  local results = {}
  
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

return M
