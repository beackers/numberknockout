local M = {}
local perms = require("permutations")

--[[
This is the calculations module.
Everything here happens given two things:
- a table of the current permutation of numbers
- a table of the current permutation of operators
]]

-- operators
local ops = {
  ["+"] = function(a, b) return a + b end,
  ["-"] = function(a, b) return a - b end,
  ["*"] = function(a, b) return a * b end,
  ["/"] = function(a, b) return a / b end,
  ["%"] = function(a, b) return a % b end
}

-- given list, return subset
function sublist(list, start, finish)
  local result = {}
  for i = start, finish do
    table.insert(result, list[i])
  end
  return result
end

-- given numbers, build possible tree structures
function buildTrees(nums)
  if #nums == 1 then
    return {
      { value = nums[1] }
    }
  end

  local trees = {}

  for i = 1, #nums - 1 do
    local leftNums  = sublist(nums, 1, i)
    local rightNums = sublist(nums, i + 1, #nums)

    local leftTrees  = buildTrees(leftNums)
    local rightTrees = buildTrees(rightNums)

    for _, L in ipairs(leftTrees) do
      for _, R in ipairs(rightTrees) do
        table.insert(trees, {
          left = L,
          right = R
        })
      end
    end
  end

  return trees
end

-- given list of tree structs, attach operators
function attachOps(trees, operators)
  local resultTrees = {}
  -- step 1: find operator nodes
  local function collectInternalNodes(node, list)
    if node.value then return end
    table.insert(list, node)
    collectInternalNodes(node.left, list)
    collectInternalNodes(node.right, list)
  end

  -- step three: clone and assign operators
  local function clone(node)
    if node.value then
      return { value = node.value }
    end

    return {
      left = clone(node.left),
      right = clone(node.right)
    }
  end

  for _, tree in ipairs(trees) do
    local nodes = {}
    collectInternalNodes(tree, nodes)
    local k = #nodes
    local opsequences = perms.permuteOps(operators, k)
    for _, seq in ipairs(opsequences) do
      local newTree = clone(tree)
      local nodes = {}
      collectInternalNodes(newTree, nodes)

      for i, op in ipairs(seq) do
        if nodes[i] then
          nodes[i].op = op
        else
          error("Mismatch: more operators than nodes")
        end
      end
      
      table.insert(resultTrees, newTree)
    end
  end
  return resultTrees
end

-- given tree, completely evaluate
function eval(node)
  if node.value then
    return node.value
  end

  local a = eval(node.left)
  local b = eval(node.right)
  if a == nil or b == nil or node.op == nil then
    return nil
  end

  local ok, result = pcall(function() return ops[node.op](a, b) end )
  if ok then
    return ops[node.op](a, b)
  else return nil end
end


-- main calculate function
function M.calc(numbers, operators)
  local trees = buildTrees(numbers)
  trees = attachOps(trees, operators)
  local results = {}
  for _, tree in ipairs(trees) do
    table.insert(results, eval(tree))
  end
  return results
end

return M
