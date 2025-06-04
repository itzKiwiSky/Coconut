return function(coconut)
    local scene = coconut.Scene.newScene("myScene")
    local myFirstObject

    print(inspect(scene))

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
        myFirstObject.scale.x = 0.5
        myFirstObject.scale.y = 0.5

        scene:add(text)
        scene:add(myFirstObject)
    end

    function scene.onMousepressed(x, y, button)
        print(x, y, button)
        if button == 1 then
            myFirstObject.pos.x = x
            myFirstObject.pos.y = y
        end
        
    end

    coconut.Scene.switch("myScene")
end