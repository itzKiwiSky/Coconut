return function()
    local Engine = import 'Engine'
    local Signal = import 'utils.Signal'

    local DataHolderComponent = {
        stack = {}
    }

    function DataHolderComponent:add(key, value)
        if not DataHolderComponent.stack[key] then
            DataHolderComponent.stack[key] = value
        end
    end

    function DataHolderComponent:get(key)
        if not DataHolderComponent.stack[key] then
            return DataHolderComponent.stack[key]
        end
    end

    

    return DataHolderComponent
end