
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
    table.insert(Log.data, string.format(...))
end

return Log