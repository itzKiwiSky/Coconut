local LPASSETS = (...):match('(.-)[^/]+$')
local vec2 = import 'Math.Vec2'
local Color = import 'Utils.Color'
local assets = import 'utils.AssetPool'

return function(...)

    ---@class coconut.components.graphics.SpriteComponent
    local SpriteComponent = {
        name = "Sprite",
        drawable = assets.get(assets.AssetType.IMAGE, "logo"),
        scale = vec2:new(1, 1),
        origin = vec2.ZERO(),
        shear = vec2.ZERO(),
        rotation = 0,
        color = Color.WHITE,
    }

    function SpriteComponent:__draw()
        if not self then
            self = {
                pos = vec2.ZERO()
            }
        end
        if not self.pos then self.pos = vec2.ZERO() end
        love.graphics.setColor(type(self.color) == "table" and self.color or Color.fromInt(self.color))
            love.graphics.draw(
                self.drawable,
                self.pos.x, self.pos.y, math.rad(self.rotation),
                self.scale.x, self.scale.y, self.origin.x, self.origin.y,
                self.shear.x, self.shear.y
            )
        love.graphics.setColor(1, 1, 1, 1)
    end

    function SpriteComponent:centerOrigin()
        local dw, dh = self.drawable:getDimensions()
        self.origin = vec2:new(dw / 2, dh / 2)
    end

    return SpriteComponent
end