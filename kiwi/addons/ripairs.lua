function ripairs(t)
    local i = #t + 1
    return function()
        i = i - 1
        if i > 0 then
            return i, t[i]
        end
    end
end

return ripairs