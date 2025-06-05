local Color = import 'utils.Color'
local COCONUT_PATH = (...):match('(.-)[^/]+$')

local logFont = love.graphics.newFont(18)

---@class coconut.utils.Log
local Log = {
    data = {}
}
--- Set the default lifetime for logs 
--- @type integer
Log.defaultLifetime = 15

--- Set the max lines the log can display
--- @type integer
Log.maxLogLineDisplay = 20

--- Set the log background color 
--- @type coconut.utils.Color
Log.backgroundColor = Color.fromInt(0x00000069) -- fun number --

---@type coconut.utils.Log.WarnLevel
Log.WarnLevel = {
    INFO = "info",
    WARN = "warn",
    ERROR = "error",
    DEPRECATED = "deprecated"
}

local logColors = {
    ["info"] = Color.DARKGRAY,
    ["warn"] = Color.GOLD,
    ["error"] = Color.fromInt(0xF34736FF),
    ["deprecated"] = Color.BROWN,
}

---Set the log font
---@param font Font
function Log.setFont(font)
    logFont = font
end

--- Traces a message to the system log
---@param level coconut.utils.Log.WarnLevel         Defines the warning level of the message
---@param ... varargs                           message itself
function Log.trace(level, ...)
    table.push(Log.data, {
        level = level or Log.WarnLevel.INFO,
        time = love.timer.getTime(),
        text = string.format(...),
        color = logColors[level],
        meta = {
            lifetime = Log.defaultLifetime,
        }
    })
end

---@protected
function Log.draw() 
    local startY = _push.getWidth() - logFont:getHeight() - 10
    for idx, line in ripairs(Log.data) do
        if idx <= Log.maxLogLineDisplay then
            local textWidth = logFont:getWidth(line.text) + 10
            local x, y = 10, startY


            love.graphics.setColor(Log.backgroundColor)
                love.graphics.rectangle("fill", x - 5, y - 5, textWidth, logFont:getHeight() + 10, 5)
            love.graphics.setColor(1, 1, 1, 1)

            love.graphics.setColor(line.color)
                love.graphics.print(line.text, logFont, x, y)
            love.graphics.setColor(1, 1, 1, 1)

            startY = startY - logFont:getHeight() - 10
        end
    end
end

---@protected
---@param elapsed float
function Log.update(elapsed)
    for idx, line in ripairs(Log.data) do
        line.meta.lifetime = line.meta.lifetime - elapsed

        if line.meta.lifetime <= 0.4 then
            if line.color[4] < 0 then
                line.color[4] = line.color[4] - elapsed
                return
            end
            table.remove(Log.data, idx)
        end
    end
end

return Log