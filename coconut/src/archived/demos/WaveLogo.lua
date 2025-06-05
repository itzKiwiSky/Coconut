return function(coconut)
    local scene = coconut.Scene.newScene("myScene")
    local myFirstObject

    function scene.onSceneEnter()
        local text = coconut.Object({
            coconut.Components.Transform,
            coconut.Components.Text
        })
    
        text.text = "We are waving"
        text.align = text.Alignment.CENTER
        text.textLimit = coconut.Engine.width
    
        myFirstObject = coconut.Object({
            coconut.Components.Transform,
            coconut.Components.Sprite
        })
    
        myFirstObject:centerOrigin()
        myFirstObject:center()
        myFirstObject.scale.x = 0.5
        myFirstObject.scale.y = 0.5

        scene:add(text)
        scene:add(myFirstObject)
    end

    function scene.onSceneUpdate()
        myFirstObject.pos.y = coconut.Math.wave(128, coconut.Engine.height - 256, love.timer.getTime() * 3)
    end

    coconut.Scene.switch("myScene")
end