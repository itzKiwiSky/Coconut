local LPASSETS = (...):match('(.-)[^/]+$')
local vec2 = import 'Math.Vec2'
local Color = import 'Utils.Color'

return function()
    ---@class Loveplay.Components.TextRendererComponent
    local TextRendererComponent = {}

    TextRendererComponent.ALIGNMENT = { LEFT = "left", CENTER = "center", RIGHT = "right" }

    TextRendererComponent.font = Dino2D.assets.get(Dino2D.assets.ASSETTYPE.FONT, "fredoka", { fontsize = 25 })
    TextRendererComponent.text = ""
    TextRendererComponent.color = Color.BLACK
    TextRendererComponent.align = TextRendererComponent.ALIGNMENT.CENTER
    TextRendererComponent.offsetPos = vec2.ZERO()
    TextRendererComponent.textLimit = 128
    TextRendererComponent.shadow = false
    TextRendererComponent.shadowColor = Color.fromInt(0x00000080)
    TextRendererComponent.shadowOffset = vec2(2, 2)

    function TextRendererComponent:__draw()
        love.graphics.setColor(self.color)
            love.graphics.printf(self.text, self.font, self.pos.x, self.pos.y, self.textLimit, self.align)
            if self.shadow then
                love.graphics.setColor(self.shadowColor)
                love.graphics.printf(self.text, self.font, self.pos.x + self.shadowOffset.x, self.pos.y + self.shadowOffset.y, self.textLimit, self.align)
            end
            love.graphics.setColor(1, 1, 1, 1)
    end

    return TextRendererComponent
end