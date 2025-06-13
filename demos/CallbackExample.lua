return function(coconut)
    local scene = coconut.Scene.newScene("myScene")
    local myFirstObject

    function scene.onSceneEnter()
        local text = coconut.Object({
            coconut.Components.Transform,
            coconut.Components.Text
        })
    
        text.text = "We are callbacking"
        text.align = text.Alignment.CENTER
        text.textLimit = coconut.Engine.width
    
        myFirstObject = coconut.Object({
            coconut.Components.Transform,
            coconut.Components.Sprite
        })
    
        myFirstObject:centerOrigin()
        myFirstObject:center()
        myFirstObject.scale.x = 0.25
        myFirstObject.scale.y = 0.25

        scene:add(text)
        scene:add(myFirstObject)
    end

    function scene.onMousepressed(x, y, button)
        if button == 1 then
            myFirstObject.pos.x = x
            myFirstObject.pos.y = y
        end
    end

    function scene.onSceneUpdate(elapsed)
        --myFirstObject.pos.x = myFirstObject.pos.x + elapsed * 0.5
    end

    coconut.Scene.switch("myScene")
end