return function(coconut)
    local myFirstObject = coconut.Object({
        coconut.Components.Transform,
        coconut.Components.Sprite
    })

    --print(inspect(myFirstObject))

    --myFirstObject.Sprite:centerOrigin()
    --myFirstObject.Transform:center()
    --myFirstObject.Sprite.scale.x = 0.5
    --myFirstObject.Sprite.scale.y = 0.5

    coconut.Scene.add(myFirstObject)
end