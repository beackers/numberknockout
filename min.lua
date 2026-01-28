local heap = {
  data = {}
}

function heap.push(state)
  heap.data[#heap.data + 1] = state
  table.sort(heap.data, function(a, b)
    return a.score < b.score
  end)
end

function heap.pop()
  return table.remove(heap.data, 1)
end

function heap.isEmpty()
  return #heap.data == 0
end

return heap
