return function()
    local Engine = import 'Engine'
    local vec2 = import 'Math.Vec2'

    local TransformComponent = {
        pos = vec2.ZERO(),
        z = 0,
    }

    function TransformComponent:center(this)
        self.pos.x, self.pos.y = Engine.width / 2, Engine.height / 2
    end

    return TransformComponent
end