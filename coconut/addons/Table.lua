function table.contains(_table, _value)
    for _, v in ipairs(_table) do
        if v == _value then
            return true
        end
    end
    return false
end

function table.push(t, ...)
    local n = select("#", ...)
    for i = 1, n do
        t[#t + 1] = select(i, ...)
    end
    return ...
end

function table.pop(t)
    return table.remove(t)
end

function table.unshift(t, ...)
    local n = select("#", ...)
    for i = n, 1, -1 do
        table.insert(t, 1, select(i, ...))
    end
    return ...
end

function table.shift(t)
    return table.remove(t, 1)
end

function table.concatf(tbl, sep, transform)
    sep = sep or ""
    transform = transform or function(k, v) return v end
    
    local result = {}
    for k, v in pairs(tbl) do
        result[#result + 1] = transform(k, v)
    end
    
    return table.concat(result, sep)
end

function table.find(t, val, idx)
    idx = idx or 1
    if idx < 0 then idx = #t + idx + 1 end
    for i = idx,#t do
        if t[i] == val then return i end
    end
    return nil
end

function table.compare(t1, t2)
    if type(t1) ~= "table" or type(t2) ~= "table" then return false end

    for k in pairs(t1) do
        if t2[k] == nil then return false end
    end

    for k in pairs(t2) do
        if t1[k] == nil then return false end
    end

    for k, v in pairs(t1) do
        if type(v) == "table" and type(t2[k]) == "table" then
            if not table.compare(v, t2[k]) then return false end
        elseif v ~= t2[k] then return false end
    end

    return true
end

function table.clear(t)

    local getiter = function(x)
        if type(x) == "table" and x[1] ~= nil then
            return ipairs
        elseif type(x) == "table" then
            return pairs
        end
        error("expected table", 3)
    end

    local iter = getiter(t)
    for k in iter(t) do
        t[k] = nil
    end
    return t
end

function table.deepmerge(target, source)
    if type(target) ~= "table" or type(source) ~= "table" then
        return target
    end

    if getmetatable(source) then
        setmetatable(target, getmetatable(source))
    end

    for key, value in pairs(source) do
        if type(value) == "table" then
            if type(target[key]) ~= "table" then
                target[key] = {}
            end
            table.deepmerge(target[key], value)
        else
            target[key] = value
        end
    end

    return target
end

function table.indexOf(table, element)
    for index, elem in ipairs(table) do
        if elem == element then
            return index
        end
    end
    return -1
end

function table.removeItem(t, item)
    table.remove(t, table.indexOf(t, item))
end

function table.filter(t, func)
    local filtered = {}
    for _, value in ipairs(t) do
        if func(value) then
            table.insert(filtered, value)
        end
    end
    return filtered
end

function table.join(t, sep)
    if sep == nil then
        sep = ""
    end

    local tl = #t
    local result = ""

    for i, value in ipairs(t) do
        result = result .. tostring(value)
        if i < tl then
            result = result .. sep
        end
    end

    return result
end

function table.set(list, keys, value)
    local lastKey = nil

    for _, key in ipairs(keys) do
        key, lastKey = lastKey, key

        if key == nil then goto continue end

        local parentList = list

        list = rawget(parentList, key)

        if list == nil then
            list = {}
            rawset(parentList, key, list)
        end

        if type(list) ~= "table" then error("Unexpected subtable", 2) end

        ::continue::
    end

    rawset(list, lastKey, value)
end

function table.get(list, keys)
    for index, key in ipairs(keys) do
        if list == nil then return nil end

        if type(list) ~= "table" then error("Unexpected subtable", 2) end

        list = rawget(list, key)
    end

    return list
end

return table