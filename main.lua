local coconut = require 'coconut'
local lust = nil
coconut.init()

if love.arg.parseGameArguments(arg)[1] == "--test" then
    lust = require 'tests.Libraries.lust'
    local fsutil = require 'tests.Libraries.FSUtil'

    local tests = fsutil.scanFolder("tests/specs")
    for _, test in ipairs(tests) do
        local t = require((test:gsub("/", ".")):gsub("%.lua", ""))
        t({
            lust = lust,
            coconut = coconut
        })
    end
end

local cena = coconut.Scene.newScene("roger")

function cena.onSceneEnter()
    local obj = coconut.Object({
        coconut.Components.Transform,
        coconut.Components.Sprite,
    })

    obj:centerOrigin()
    obj:center()
    obj.scale.x = 0.5
    obj.scale.y = 0.5
    
    cena:add(obj)
end

coconut.Scene.switch("roger")