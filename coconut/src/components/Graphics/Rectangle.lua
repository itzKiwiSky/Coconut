local ShapeRenderer = import 'gfx.Shape'
local vec2 = import 'Math.Vec2'
local Color = import 'Utils.Color'

return function()
    local RectangleShapeComponent = {}
    table.deepmerge(RectangleShapeComponent, ShapeRenderer())
    local shapeDraw = RectangleShapeComponent.__draw

    RectangleShapeComponent.size = {
        w = 32,
        h = 32
    }

    function RectangleShapeComponent:__init()
        if self.isDataHolder then
            error("[CoconutComponent] Can't add other components inside a dataholder component")
        end

        self.verts = {
            self.pos.x, self.pos.y,
            self.pos.x + RectangleShapeComponent.size.w, self.pos.y,
            self.pos.x + RectangleShapeComponent.size.w, self.pos.y + RectangleShapeComponent.size.h,
            self.pos.x, self.pos.y + RectangleShapeComponent.size.h,
        }
    end

    function RectangleShapeComponent:__draw()
        self.verts = {
            self.pos.x, self.pos.y,
            self.pos.x + RectangleShapeComponent.size.w, self.pos.y,
            self.pos.x + RectangleShapeComponent.size.w, self.pos.y + RectangleShapeComponent.size.h,
            self.pos.x, self.pos.y + RectangleShapeComponent.size.h,
        }
        -- super --
        shapeDraw(self)
    end

    return RectangleShapeComponent
end