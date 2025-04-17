local vec2 = import 'Math.Vec2'
local Color = import 'Utils.Color'
local assets = import 'utils.AssetPool'

return function()
    ---@class coconut.components.TextRendererComponent
    local TextRendererComponent = {}

    ---@enum
    TextRendererComponent.Alignment = { LEFT = "left", CENTER = "center", RIGHT = "right" }

    TextRendererComponent.font = assets.get(assets.AssetType.FONT, "fredoka", { fontsize = 25 })
    TextRendererComponent.text = ""
    TextRendererComponent.color = Color.WHITE
    TextRendererComponent.align = TextRendererComponent.Alignment.CENTER
    TextRendererComponent.offsetPos = vec2.ZERO()
    TextRendererComponent.textLimit = 128
    TextRendererComponent.shadow = false
    TextRendererComponent.shadowColor = Color.fromInt(0x00000080)
    TextRendererComponent.shadowOffset = vec2:new(2, 2)

    function TextRendererComponent:__draw()
        if not self then
            self = {
                pos = vec2.ZERO()
            }
        end
        love.graphics.setColor(self.color)
            love.graphics.printf(self.text, self.font, self.pos.x, self.pos.y, self.textLimit, self.align)
            if self.shadow then
                love.graphics.setColor(self.shadowColor)
                love.graphics.printf(self.text, self.font, self.pos.x + self.shadowOffset.x, self.pos.y + self.shadowOffset.y, self.textLimit, self.align)
            end
        love.graphics.setColor(1, 1, 1, 1)
    end

    function TextRendererComponent:setFont(name, size)
        TextRendererComponent.font = assets.get(assets.AssetType.FONT, name, { fontsize = size })
    end

    if self.isDataHolder then
        error("[CoconutComponent] Can't add other components inside a dataholder component")
    end

    return TextRendererComponent
end