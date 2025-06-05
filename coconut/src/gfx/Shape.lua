local vec2 = import 'Math.Vec2'
local Color = import 'Utils.Color'

return function()
    ---@protected
    ---@class coconut.components.ShapeRendererComponent
    local ShapeRendererComponent = {}

    ShapeRendererComponent.FILLSTYLE = {
        FILL = "fill",
        LINE = "line"
    }

    ShapeRendererComponent.verts = {}
    ShapeRendererComponent.fillmode = ShapeRendererComponent.FILLSTYLE.FILL
    ShapeRendererComponent.color = Color.WHITE

    function ShapeRendererComponent:__draw()
        if #self.verts >= 3 then
            love.graphics.setColor(type(self.color) == "table" and self.color or Color.fromInt(self.color))
            love.graphics.polygon(self.fillmode, self.verts)
        end
        love.graphics.setColor(1, 1, 1, 1)
    end

    return ShapeRendererComponent
end