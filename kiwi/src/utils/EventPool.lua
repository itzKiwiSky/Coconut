local EventPool = {}

EventPool.stack = {}

function EventPool.clear()
    table.clear(EventPool.stack)
end

function EventPool.push(event)
    table.push(EventPool.stack, event)
end

function EventPool.execute()
    
end

return EventPool