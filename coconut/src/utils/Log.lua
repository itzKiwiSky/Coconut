
---@class lux.utils.Log
local Log = {
    data = {}
}

---@type lux.utils.Log.WarnLevel
Log.WarnLevel = {
    INFO = "info",
    WARN = "warn",
    ERROR = "error",
    DEPRECATED = "deprecated"
}

--- Traces a message to the system log
---@param level lux.utils.Log.WarnLevel         Defines the warning level of the message
---@param ... varargs                           message itself
function Log.trace(level, ...)
    table.push(Log.data, {
        level = level or Log.WarnLevel.INFO,
        time = love.timer.getTime(),
        text = string.format(...)
    })
end

return Log