local kiwi = require 'kiwi'

kiwi.init({debug = true})

kiwi.scene.newScene("input", function(scene)
    local obj = kiwi.object({
        kiwi.Components.Transform,
        kiwi.Components.Drawable,
    })

    local text = kiwi.object({
        kiwi.Components.Transform,
        kiwi.Components.Text,
    })

    text.text = "Press space to toogle visibility"
    text:center()
    text.pos.y = 128

    text:setFont("fredoka", 30)

    obj.scale = kiwi.Vec2:new(0.1)
    obj:centerOrigin()
    obj:center()

    scene.add(text)
    scene.add(obj)

    scene.onUpdate = function()
        if kiwi.input.getKey(kiwi.KEYS.SPACE) then
            obj.visible = not obj.visible
        end
    end
end)

kiwi.scene.switchScene("input")