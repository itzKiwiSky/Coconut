local bit = require 'bit'

---@class lux.utils.Color
local Color = {}

--- @protected
--- @param hex integer
--- @return table<float>
local function hexToRGBA(hex)
    local r = bit.band(bit.rshift(hex, 24), 0xFF) / 255
    local g = bit.band(bit.rshift(hex, 16), 0xFF) / 255
    local b = bit.band(bit.rshift(hex, 8), 0xFF) / 255
    local a = bit.band(hex, 0xFF) / 255-- Se não houver alpha, assume 1.0

    -- Se o valor for totalmente transparente (0x00000000), força o alpha para 0
    if hex == 0x00000000 then
        a = 0
    end

    return { r, g, b, a }
end

Color.TRANSPARENT   =       hexToRGBA(0x00000000)
Color.BLACK         =       hexToRGBA(0x000000FF)
Color.WHITE         =       hexToRGBA(0xFFFFFFFF)
Color.RED           =       hexToRGBA(0xFF0000FF)
Color.GREEN         =       hexToRGBA(0x00FF00FF)
Color.BLUE          =       hexToRGBA(0x0000FFFF)
Color.YELLOW        =       hexToRGBA(0xFFFF00FF)
Color.PURPLE        =       hexToRGBA(0xFF00FFFF)
Color.CYAN          =       hexToRGBA(0x00FFFFFF)
Color.PINK          =       hexToRGBA(0xFFC0CBFF)
Color.GRAY          =       hexToRGBA(0x808080FF)
Color.LIGHTGRAY     =       hexToRGBA(0xD3D3D3FF)
Color.DARKGRAY      =       hexToRGBA(0xA9A9A9FF)
Color.ORANGE        =       hexToRGBA(0xFFA500FF)
Color.BROWN         =       hexToRGBA(0xA52A2AFF)
Color.GOLD          =       hexToRGBA(0xFFD700FF)
Color.SILVER        =       hexToRGBA(0xC0C0C0FF)
Color.TEAL          =       hexToRGBA(0x008080FF)
Color.NAVY          =       hexToRGBA(0x000080FF)
Color.OLIVE         =       hexToRGBA(0x808000FF)
Color.MAROON        =       hexToRGBA(0x800000FF)
Color.LIME          =       hexToRGBA(0x00FF00FF)
Color.MAGENTA       =       hexToRGBA(0xFF00FFFF)

--- Convert any decimal to a color in RRGGBBAA
---@param int number    The hexadecimal value of color
---@return table
function Color.fromInt(int) return hexToRGBA(int) end

return Color