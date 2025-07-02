return function()
    local Engine = import 'Engine'
    local vec2 = import 'Math.Vec2'

    ---@class coconut.components.TransformComponent
    local TransformComponent = {
        name = "Transform",
        pos = vec2.ZERO(),
        z = 0,
    }

    function TransformComponent:center()
        self.pos.x, self.pos.y = Engine.width / 2, Engine.height / 2
    end

    function TransformComponent:centerX()
        self.pos.x = Engine.width / 2
    end

    function TransformComponent:centerY()
        self.pos.y = Engine.height / 2
    end

    return TransformComponent
end