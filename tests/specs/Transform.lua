return function(libraries)
    local lust = libraries.lust
    local coconut = libraries.coconut

    lust.describe("Transform Component", function()
        lust.it("Check the component integration with object", function()
            local obj = coconut.Object({
                coconut.Components.Transform
            })

            coconut.Scene.add(obj)

            lust.expect(obj.pos).to.exist()
            lust.expect(obj.pos.x).to.exist()
            lust.expect(obj.pos.y).to.exist()
            lust.expect(obj.pos.x).to.be.a("number")
            lust.expect(obj.pos.y).to.be.a("number")
            
        end)

        lust.describe("Check coordinate system", function()
            lust.it("Check vector values is changing", function()
                local obj = coconut.Object({
                    coconut.Components.Transform
                })
                
                local oldX, oldY = obj.pos:unpack()

                obj.pos.x = 90
                obj.pos.y = 90

                lust.expect(obj.pos.x).to_not.be(oldX)
                lust.expect(obj.pos.y).to_not.be(oldY)
            end)
        end)

        lust.describe("Vector operations", function()
            lust.it("Should do vectors addition", function()
                local obj = coconut.Object({
                    coconut.Components.Transform
                })

                obj.pos:add(coconut.Vec2:new(32, 32))
                lust.expect(obj.pos.x).to.be(32)
                lust.expect(obj.pos.y).to.be(32)
            end)

            lust.it("Should do vectors subtraction", function()
                local obj = coconut.Object({
                    coconut.Components.Transform
                })

                obj.pos.x, obj.pos.y = 90, 90

                obj.pos:sub(coconut.Vec2:new(32, 32))
                lust.expect(obj.pos.x).to.be(58)
                lust.expect(obj.pos.y).to.be(58)
            end)
            
            lust.it("Should do vectors multiplication", function()
                local obj = coconut.Object({
                    coconut.Components.Transform
                })

                obj.pos = coconut.Vec2:new(32)

                obj.pos:mul(32)
                lust.expect(obj.pos.x).to.be(1024)
                lust.expect(obj.pos.y).to.be(1024)
            end)
            
            lust.it("Should do vectors division", function()
                local obj = coconut.Object({
                    coconut.Components.Transform
                })

                obj.pos = coconut.Vec2:new(1024)

                obj.pos:div(32)
                lust.expect(obj.pos.x).to.be(32)
                lust.expect(obj.pos.y).to.be(32)
            end)

            lust.it("Should return magnitude length", function()
                local v = coconut.Vec2:new(3, 4)
                lust.expect(v:len()).to.be(5)
            end)
        
            lust.it("normaliza corretamente", function()
                local v = coconut.Vec2:new(3, 4):normalize()
                lust.expect(math.floor(v:len())).to.be(0)
            end)

            lust.it("Should return dot product of other vector", function()
                local a = coconut.Vec2.RIGHT()
                local b = coconut.Vec2.DOWN()
                lust.expect(a:dot(b)).to.be(0)
            end)
        end)
    end)
end