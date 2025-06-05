return function(coconut)
    local myFirstObject = coconut.Object({
        coconut.Components.Transform,
        coconut.Components.Sprite
    })

    myFirstObject:centerOrigin()
    myFirstObject:center()
    myFirstObject.scale.x = 0.5
    myFirstObject.scale.y = 0.5

    coconut.Scene.add(myFirstObject)
end