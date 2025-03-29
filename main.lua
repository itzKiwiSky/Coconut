local lux = require 'lux'
local lust = nil

if love.arg.parseGameArguments(arg)[1] == "--test" then
    lust = require 'Tests.Libraries.lust'
    local fsutil = require 'Tests.Libraries.FSUtil'

    local tests = fsutil.scanFolder("Tests/suites")
    for _, test in ipairs(tests) do
        local t = require((test:gsub("/", ".")):gsub("%.lua", ""))
        t({
            lust = lust,
            lux = lux
        })
    end
end

lux.init({debug = true})

lux.scene.newScene("idea", function(scene)
    local obj = lux.object({
        lux.Components.Transform,
        lux.Components.Drawable,
    })
    
    local text = lux.object({
        lux.Components.Transform,
        lux.Components.Text,
    })
    

    obj:centerOrigin()

    scene.add(obj)

    print(inspect(lux.scene.gameScenes["idea"]))
end)

lux.scene.switchScene("idea")