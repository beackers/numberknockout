local heap = { data = {} }

local function priority(state)
  return state.score + state.depth
end

local function siftUp(data, idx)
  while idx > 1 do
    local parent = math.floor(idx / 2)
    if priority(data[parent]) <= priority(data[idx]) then
      break
    end
    data[parent], data[idx] = data[idx], data[parent]
    idx = parent
  end
end

local function siftDown(data, idx)
  local size = #data
  while true do
    local left = idx * 2
    local right = left + 1
    local smallest = idx

    if left <= size and priority(data[left]) < priority(data[smallest]) then
      smallest = left
    end
    if right <= size and priority(data[right]) < priority(data[smallest]) then
      smallest = right
    end
    if smallest == idx then
      break
    end
    data[idx], data[smallest] = data[smallest], data[idx]
    idx = smallest
  end
end

function heap.push(state)
  local data = heap.data
  data[#data + 1] = state
  siftUp(data, #data)
end

function heap.pop()
  local data = heap.data
  if #data == 0 then
    return nil
  end
  local root = data[1]
  local last = table.remove(data)
  if #data > 0 then
    data[1] = last
    siftDown(data, 1)
  end
  return root
end

function heap.isEmpty()
  return #heap.data == 0
end

return heap
