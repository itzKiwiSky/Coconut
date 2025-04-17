return function()
    local Engine = import 'Engine'
    local Signal = import 'utils.Signal'

    local DataHolderComponent = {
        stack = {},
        isDataHolder = true,
    }

    function DataHolderComponent:add(key, value)
        if not DataHolderComponent.stack[key] then
            DataHolderComponent.stack[key] = value
        end
    end

    function DataHolderComponent:get(key)
        if DataHolderComponent.stack[key] then
            return DataHolderComponent.stack[key]
        end
    end

    function DataHolderComponent:exists(key)
        return DataHolderComponent.stack[key] ~= nil
    end

    function DataHolderComponent:remove(key)
        if DataHolderComponent.stack[key] then
            DataHolderComponent.stack[key] = nil
        end

        collectgarbage("collect")
    end

    return DataHolderComponent
end