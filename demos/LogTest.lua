return function(coconut)
    local time = 0
    for i = 1, 10, 1 do
        while time < 50 do
            time = time + 1
        end
        if time >= 10 then
            coconut.Debug.trace(coconut.Debug.WarnLevel.ERROR, "Your code sucks, please delete it :)")
            time = 0
        end
    end
end