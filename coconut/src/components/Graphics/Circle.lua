local ShapeRenderer = import 'gfx.Shape'
local vec2 = import 'Math.Vec2'
local Color = import 'Utils.Color'

return function()
    local CircleShapeComponent = {}
    table.deepmerge(CircleShapeComponent, ShapeRenderer())
    CircleShapeComponent.__super = CircleShapeComponent.__draw
    
    CircleShapeComponent.radius = 32
    CircleShapeComponent.segments = 30

    local function CreateCirclePolygon(segments, radius, x, y)
        segments = segments or 40
        radius = radius or 50
        x = x or 0
        y = y or 0
    
        local vertices = {}
    
        -- Primeiro vértice é o centro do círculo
        table.insert(vertices, x)
        table.insert(vertices, y)
    
        -- Criar os vértices na borda do círculo
        for i = 0, segments do
            local angle = (i / segments) * math.pi * 2
            local px = x + math.cos(angle) * radius
            local py = y + math.sin(angle) * radius
            table.insert(vertices, px)
            table.insert(vertices, py)
        end
    
        return vertices
    end
    

    function CircleShapeComponent:__onMount()
        self.verts = CreateCirclePolygon(CircleShapeComponent.segments, CircleShapeComponent.radius, self.pos.x, self.pos.y)
    end

    function CircleShapeComponent:__draw()
        self.verts = CreateCirclePolygon(CircleShapeComponent.segments, CircleShapeComponent.radius, self.pos.x, self.pos.y)
        -- super --
        CircleShapeComponent:__super()
    end

    return CircleShapeComponent
end