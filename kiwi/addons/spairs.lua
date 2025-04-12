function spairs(t, sort)
    local function collectKey(t, sort)
        local nk = {}
        for k in pairs(t) do
            nk[#nk + 1] = k 
        end
        table.sort(nk, sort)
        return nk
    end

    local ks = collectKey(t, sort)
    local i = 0
    return function()
        i = i + 1
        if ks[i] then
            return ks[i], t[ks[i]]
        end
    end
end

return spairs