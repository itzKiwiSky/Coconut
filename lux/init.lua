--- @class lux.Lux2D
local Lux2D = {}

local LUX_PATH = (...) .. "."

function import(modname)
    if modname == nil or #modname == 0 then
        return require(LUX_PATH)
    end
    return require(LUX_PATH .. "src." .. modname)
end

class = require(LUX_PATH .. "libraries.classic")
_xml = require(LUX_PATH .. "libraries.xml")
_json = require(LUX_PATH .. "libraries.json")
_lume = require(LUX_PATH .. "libraries.lume")
Lux2D.push = require(LUX_PATH .. "libraries.push")

local fsutil = require(LUX_PATH .. "FSutil")

local addons = fsutil.scanFolder(LUX_PATH .. "/addons")
for a = 1, #addons, 1 do
    local ad = addons[a]:gsub(".lua", "")
    require(ad:gsub("/", "%."))
end

-----------------------------------------------------------------------------

Lux2D.Components = {}       -- store the engine components --
Lux2D.engine = import 'Engine'
Lux2D.scene = import 'core.Scene'
Lux2D.object = import 'core.Object'


Lux2D.assets = import 'utils.AssetPool'
Lux2D.assets.addImage("logo", LUX_PATH .. "/assets/images/icon.png")
Lux2D.assets.addFont("fredoka", LUX_PATH .. "/assets/fonts/fredoka_regular.ttf")

Lux2D.initialized = true

function Lux2D.init(config)
    assert(Lux2D.initialized == true, "[Lux2DError] : Lux2D is already initialized")

    -- load configs --
    config = config or {}
    local conf = {
        width = config.width or 640,
        height = config.height or 480,
        vsync = config.vsync or false,
        title = config.title or "Powered with Lux2D",
        scene = config.scene or "root",
        resizable = config.resizable or true,
        fullscreen = config.fullscreen or false,
        packageid = config.packageid or "Lux2D.game",
        fpscap = config.fpscap or 60,
        unfocusedfps = config.unfocusedfps or 25,
        errhand = config.errhand or nil,
        debug = config.debug or false,
        global = config.global or false,
        antialiasing = config.antialiasing or false,
        extensions = config.extensions or {}
    }

    love.graphics.setDefaultFilter(
        conf.antialiasing and "linear" or "nearest",
        conf.antialiasing and "linear" or "nearest"
    )

    love.window.setMode(conf.width, conf.height, { resizable = conf.resizable, vsync = conf.vsync, fullscreen = conf.fullscreen })

    local mainCanvas = love.graphics.newCanvas(conf.width, conf.height)
    mainCanvas:setFilter(
        conf.antialiasing and "linear" or "nearest",
        conf.antialiasing and "linear" or "nearest"
    )

    -- load components --
    local components = fsutil.scanFolder(LUX_PATH .. "/src/Components")
    for c = 1, #components, 1 do
        local comp = components[c]:gsub(".lua", "")
        Lux2D.Components[components[c]:match("[^/]+$"):gsub(".lua", "")] = require(comp:gsub("/", "%."))
    end

    Lux2D.push.setupScreen(conf.width, conf.height, { upscale = conf.antialiasing and "normal" or "pixel-perfect" })
    
    Lux2D.engine.width = Lux2D.push.getWidth()
    Lux2D.engine.height = Lux2D.push.getHeight()

    -- create a default scene --
    Lux2D.scene.newScene(conf.scene, function() end)
    Lux2D.scene.switchScene(conf.scene)

    love.window.setTitle(conf.title)
    love.filesystem.setIdentity(conf.packageid)

    love.run = function()
        love._FPSCap = conf.fpscap
        love._unfocusedFPSCap = conf.unfocusedfps

        love.math.setRandomSeed(os.time())
        math.randomseed(os.time())
    
        local fpsfont = Lux2D.assets.get(Lux2D.assets.AssetType.FONT, "fredoka", { fontsize = 18 })

        Lux2D.engine.onLoad:trigger()

        if love.timer then love.timer.step() end

        local elapsed = 0

        return function()
            if love.event then
                love.event.pump()
                for name, a,b,c,d,e,f in love.event.poll() do
                    if name == "quit" then
                        Lux2D.engine.onQuit:trigger()
                        if not love.quit or not love.quit() then
                            return a or 0
                        end
                    elseif name == "resize" then
                        Lux2D.push.resize(a, b)
                        Lux2D.engine.onWindowResize:trigger(a, b)
                    end

                    -- process other events --
                    love.handlers[name](a,b,c,d,e,f)
                end
            end

            local isFocused = love.window.hasFocus()
            Lux2D.engine.onWindowStateChange:trigger(love.window.hasFocus())
    
            local fpsCap = isFocused and love._FPSCap or love._unfocusedFPSCap
            if love.timer then 
                elapsed = love.timer.step() * Lux2D.engine.timeScale
            end

            Lux2D.scene.update(elapsed)
            
            if love.graphics and love.graphics.isActive() then
                love.graphics.origin()

                love.graphics.push("all")
                    love.graphics.setCanvas(mainCanvas)
                        love.graphics.clear(love.graphics.getBackgroundColor())
                        Lux2D.engine.onSceneDraw:trigger()
                        Lux2D.scene.draw()
                    love.graphics.setCanvas()
                love.graphics.pop()

                Lux2D.engine.onPreDraw:trigger()
                love.graphics.origin()
                love.graphics.clear(love.graphics.getBackgroundColor())
                
                    love.graphics.setColor(1, 1, 1, 1)
                    Lux2D.push.start()
                        
                        Lux2D.engine.onDraw:trigger()
                        love.graphics.draw(mainCanvas)

                        love.graphics.setColor(0, 0, 0, 0.5)
                            love.graphics.rectangle("fill", 0, 0, fpsfont:getWidth("FPS: " .. love.timer.getFPS()) + 10, fpsfont:getHeight() + 10, 5)
                        love.graphics.setColor(1, 1, 1, 1)
                        love.graphics.print("FPS: " .. love.timer.getFPS(), fpsfont, 5, 5)

                    Lux2D.push.finish()
    
                love.graphics.present()

                Lux2D.engine.onPostDraw:trigger()
            end

            love.timer.sleep(1 / fpsCap - elapsed)
        end
    end

    Lux2D.initialized = false
end

return Lux2D