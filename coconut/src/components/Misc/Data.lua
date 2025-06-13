return function()
    local Engine = import 'Engine'
    local Signal = import 'utils.Signal'

    ---@class coconut.components.DataComponent
    local DataComponent = {
        name = "Data",
        stack = {},
        isDataHolder = true,
    }

    function DataComponent:add(key, value)
        if not DataComponent.stack[key] then
            DataComponent.stack[key] = value
        end
    end

    function DataComponent:get(key)
        if DataComponent.stack[key] then
            return DataComponent.stack[key]
        end
    end

    function DataComponent:exists(key)
        return DataComponent.stack[key] ~= nil
    end

    function DataComponent:remove(key)
        if DataComponent.stack[key] then
            DataComponent.stack[key] = nil
        end

        collectgarbage("collect")
    end

    function DataComponent:clear()
        if DataComponent.stack then
            for key in pairs(DataComponent.stack) do
                DataComponent.stack[key] = nil
            end
        end

        collectgarbage("collect")
    end

    return DataComponent
end