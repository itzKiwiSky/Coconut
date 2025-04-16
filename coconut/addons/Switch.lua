function switch(var, case_table)
    --local case = case_table[var]
    if case_table[var] then 
        return case_table[var]() 
    end
    return case_table["default"] and case_table["default"]() or nil
end

return switch