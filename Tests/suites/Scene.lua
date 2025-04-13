return function(libraries)
    local lust = libraries.lust
    local dino2d = libraries.dino2d

    lust.describe("Scene operations", function()
        lust.it("create a bunch of objects and check the scene object count", function()
        
            dino2d.scene.newScene("test_object", function(scene)
                for o = 1, 10, 1 do
                    dino2d.object({
                        dino2d.components.Transform,
                    })

                    dino2d.scene.add(o)
                end
            end)

            dino2d.scene.switchScene("test_object")
            
            local newObjCount = dino2d.scene.getObjectCount()

            lust.expect(newObjCount).to.be.a("number")
            lust.expect(newObjCount).to_not.be(0)
        end)

        lust.it("Delete all object by reseting the scene", function()
            lust.expect(dino2d.scene.reset).to.exist()
            local oldObjCount = dino2d.scene.getObjectCount()

            dino2d.scene.reset()

            local newObjCount = dino2d.scene.getObjectCount()

            lust.expect(newObjCount).to_not.be(oldObjCount)
        end)
    end)
end