local kiwi = require 'kiwi'
local lust = nil

if love.arg.parseGameArguments(arg)[1] == "--test" then
    lust = require 'Tests.Libraries.lust'
    local fsutil = require 'Tests.Libraries.FSUtil'

    local tests = fsutil.scanFolder("Tests/suites")
    for _, test in ipairs(tests) do
        local t = require((test:gsub("/", ".")):gsub("%.lua", ""))
        t({
            lust = lust,
            kiwi = kiwi
        })
    end
end

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