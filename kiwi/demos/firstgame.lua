--[[

Create a new scene and add a object with drawable component

]]--


local kiwi = require 'kiwi'

kiwi.init({debug = true})

kiwi.scene.newScene("idea", function(scene)
    local obj = kiwi.object({
        kiwi.Components.Transform,
        kiwi.Components.Drawable,
    })
    
    local text = kiwi.object({
        kiwi.Components.Transform,
        kiwi.Components.Text,
    })

    obj.scale = kiwi.Vec2:new(0.32)
    obj:centerOrigin()
    obj:center()

    scene.add(obj)
end)

kiwi.scene.switchScene("idea")