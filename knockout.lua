local calc = require("calculations")

-- statistics (for nerds)
local stats = {
  calls = 0,
  rawcalls = 0,
  pruned = {},
  leaves = 0
}
stats.depth = {}
stats.uniqueStates = {}


-- get numbers
local numbers = {}

for i = 1, #arg do
  table.insert(numbers, {
    value = tonumber(arg[i]),
    exp = 1,
    history = tostring(arg[i])
  })
end

local allowedExps = {0, 0.5, 1, 2}
local function expandExponents(n)
  local out = {}

  for _, e in ipairs(allowedExps) do
    local candidate = {
      value = n.value,
      exp = e,
      history = (e == 1)
        and n.history
        or string.format("(%s)^%s", n.history, e)
    }

    local v = calc.eval(candidate)
    if v == v and v ~= math.huge and v ~= -math.huge then
      out[#out+1] = candidate
    end
  end

  return out
end

local function normalize(n)
  -- collapse identities only
  if n.exp == 0 then
    return { value = 1, exp = 1, history = "1" }
  end
  if n.value == 1 then
    return { value = 1, exp = 1, history = "1" }
  end
  if n.exp == 1 then
    return n
  end
  return n
end


local function normalizeState(set)
  local out = {}

  for i = 1, #set do
    out[i] = normalize(set[i])
  end
  return out
end

-- unique state id
local function numberKey(n)
  return tostring(n.value) .. "^" .. tostring(n.exp)
end

local function stateKey(numbers)
  local tmp = {}
  for i = 1, #numbers do
    tmp[#tmp+1] = numbers[i]
  end

  table.sort(tmp, function(a, b)
    if a.value ~= b.value then
      return a.value < b.value
    else
      return a.exp < b.exp
    end
  end)

  local parts = {}
  for i = 1, #tmp do
    parts[#parts+1] = "(" .. numberKey(tmp[i]) .. ")"
  end

  return table.concat(parts, ",")
end


-- calculations
local results = {}
local function search(numbers, depth)
  stats.rawcalls = stats.rawcalls + 1

  local n = #numbers
  if n == 1 then
    local v = calc.eval(numbers[1])
    if not results[v]
       or #numbers[1].history < #results[v].history then
      results[v] = numbers[1]
      stats.leaves = stats.leaves+1
    end
    return
  end

  local key = stateKey(numbers)
  if stats.uniqueStates[key] then
    stats.pruned[depth or 1] = (stats.pruned[depth or 1] or 0) + 1
    return
  end
  stats.uniqueStates[key] = true

  depth = depth or 1
  stats.depth[depth] = (stats.depth[depth] or 0) + 1
  stats.calls = stats.calls + 1

  -- BINARY OPERATIONS ONLY
  for i = 1, n - 1 do
    for j = i + 1, n do
      local a, b = numbers[i], numbers[j]

      for _, a2 in ipairs(expandExponents(a)) do
        for _, b2 in ipairs(expandExponents(b)) do
          for _, r in ipairs(calc.raws(a2, b2)) do
            local r2 = normalize(r)

            if r2.value and r2.value == math.abs(math.floor(r2.value)) then
              local next = {}
              for k = 1, n do
                if k ~= i and k ~= j then
                  next[#next+1] = numbers[k]
                end
              end
              next[#next+1] = r2
              search(next, depth + 1)
            end
          end
        end
      end
    end
  end
end

search(numbers)

-- sorting
local out = {}
for _, r in pairs(results) do
  out[#out+1] = r
end
table.sort(out, function(a, b)
  return a.value < b.value
end
)

-- uniquing
-- skipping because we set, not list, so everything's already unique

-- printing (under 100, history included)
if #out < 100 then
  for _, r in ipairs(out) do
    print(tostring(math.tointeger(calc.eval(r))), r.history)
  end
end

print("~~~~~ stats for nerds ~~~~~~~")
print("calls:", stats.calls)
print("raw calls to search():", stats.rawcalls)
print("leaves:", stats.leaves)
print("results:", #out)
for d = 1, #stats.depth do
  print("depth ", d, stats.depth[d] or 0, "pruned ", stats.pruned[d] or 0)
end
local count = 0
for _ in pairs(stats.uniqueStates) do count = count + 1 end
print("unique states:", count)
