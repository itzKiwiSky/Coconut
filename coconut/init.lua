local Coconut = {}

local COCONUT_PATH = (...) .. "."

function import(modname)
    if modname == nil or #modname == 0 then
        return require(COCONUT_PATH)
    end
    return require(COCONUT_PATH .. "src." .. modname)
end

local fsutil = require(COCONUT_PATH .. "FSutil")

local addons = fsutil.scanFolder(COCONUT_PATH .. "/addons")
for a = 1, #addons, 1 do
    local ad = addons[a]:gsub(".lua", "")
    require(ad:gsub("/", "%."))
end

class = require(COCONUT_PATH .. "libraries.classic")
_xml = require(COCONUT_PATH .. "libraries.xml")
_json = require(COCONUT_PATH .. "libraries.json")
_lume = require(COCONUT_PATH .. "libraries.lume")
_push = require(COCONUT_PATH .. "libraries.push")
_event = require(COCONUT_PATH .. "libraries.event")

Coconut.initialized = false
Coconut.Args = {}

Coconut.Components = {}
Coconut.Assets = import 'utils.AssetPool'

-- API --
Coconut.Debug = import 'utils.Log'
Coconut.Scene = import 'core.Scene'
Coconut.Engine = import 'Engine'
Coconut.Object = import 'core.Object'
Coconut.Vec2 = import 'math.Vec2'
Coconut.Math = import 'math.Math'
Coconut.Color = import 'utils.Color'

function Coconut.init(config)
    assert(Coconut.initialized == false, "[CoconutRuntimeError] : Coconut is already initialized")

    --Coconut.Event.regis

    Coconut.Assets.resetPool()

    -- load configs --
    config = config or {}
    local conf = {
        width = config.width or 640,
        height = config.height or 480,
        vsync = config.vsync or false,
        title = config.title or "Powered with Coconut",
        scene = config.scene or "root",
        resizable = config.resizable or true,
        fullscreen = config.fullscreen or false,
        packageid = config.packageid or "Coconut.game",
        fpscap = config.fpscap or 60,
        unfocusedfps = config.unfocusedfps or 25,
        errhand = config.errhand or nil,
        debug = config.debug or false,
        global = config.global or false,
        antialiasing = config.antialiasing or false,
        extensions = config.extensions or {}
    }

    Coconut.Args = conf

    love.graphics.setDefaultFilter(
        conf.antialiasing and "linear" or "nearest",
        conf.antialiasing and "linear" or "nearest"
    )

    Coconut.Assets.addImage("logo", COCONUT_PATH .. "/assets/images/icon.png")
    Coconut.Assets.addFont("fredoka", COCONUT_PATH .. "/assets/fonts/fredoka_regular.ttf")
    Coconut.Debug.setFont(Coconut.Assets.get(Coconut.Assets.AssetType.FONT, "fredoka", { fontsize = 18 }))

    -- load components --
    local components = fsutil.scanFolder(COCONUT_PATH .. "/src/Components")
    for c = 1, #components, 1 do
        local comp = components[c]:gsub(".lua", "")
        Coconut.Components[components[c]:match("[^/]+$"):gsub(".lua", "")] = require(comp:gsub("/", "%."))
    end

    local mainCanvas = love.graphics.newCanvas(conf.width, conf.height)
    mainCanvas:setFilter(
        conf.antialiasing and "linear" or "nearest",
        conf.antialiasing and "linear" or "nearest"
    )

    love.window.setMode(conf.width, conf.height, { 
        resizable = conf.resizable, 
        vsync = conf.vsync, 
        fullscreen = conf.fullscreen 
    })
    _push.setupScreen(conf.width, conf.height, { upscale = conf.antialiasing and "normal" or "pixel-perfect", canvas = true })
    
    Coconut.Engine.width =  _push.getWidth()
    Coconut.Engine.height = _push.getHeight()
    
    love.window.setTitle(conf.title)
    love.filesystem.setIdentity(conf.packageid)

    -- load scene --
    Coconut.Scene.newScene(conf.scene)

    Coconut.Scene.switch(conf.scene)

    local fpsfont = love.graphics.newFont(COCONUT_PATH .. "/assets/fonts/fredoka_regular.ttf", 18)

    love.run = function()
        love._FPSCap = conf.fpscap
        love._unfocusedFPSCap = conf.unfocusedfps

        love.math.setRandomSeed(os.time())
        math.randomseed(os.time())

        if love.timer then love.timer.step() end

        local elapsed = 0

        return function()
            if love.event then
                love.event.pump()
                for name,a,b,c,d,e,f in love.event.poll() do
                    if name == "quit" then
                        if not love.quit or not love.quit() then
                            return a or 0
                        end
                    elseif name == "resize" then
                        _push.resize(a, b)
                    end

                    -- process other events --
                    love.handlers[name](a,b,c,d,e,f)
                    Coconut.Scene.processEvents({ name, a, b, c, d, e, f })
                end
            end

            local isFocused = love.window.hasFocus()
    
            local fpsCap = isFocused and love._FPSCap or love._unfocusedFPSCap
            if love.timer then 
                elapsed = love.timer.step() * Coconut.Engine.timeScale
            end

            if love.update then
                love.update(elapsed)
            end

            if love.graphics and love.graphics.isActive() then
                love.graphics.origin()
                love.graphics.clear(love.graphics.getBackgroundColor())
                if love.draw then
                    love.draw()
                end
                love.graphics.present()
            end

            love.timer.sleep(1 / fpsCap - elapsed)
        end
    end

    love.draw = function()
        _push.start()
            Coconut.Scene.draw()

            love.graphics.setColor(0, 0, 0, 0.5)
                love.graphics.rectangle("fill", 0, 0, fpsfont:getWidth("FPS: " .. love.timer.getFPS()) + 10, fpsfont:getHeight() + 10, 5)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print("FPS: " .. love.timer.getFPS(), fpsfont, 5, 5)

            if Coconut.Args.debug then
                Coconut.Debug.draw()
            end
        _push.finish()
    end

    love.update = function(elapsed)
        Coconut.Scene.update(elapsed)

        if Coconut.Args.debug then
            Coconut.Debug.update(elapsed)
        end
    end

    love.errorhandler = function(msg)
        -- error --
        local utf8 = require("utf8")

        local function error_printer(msg, layer)
            print((debug.traceback("[CoconutError]: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
        end

        local msg = tostring(msg)

        error_printer(msg, 2)

        -- dont allow rendering the error screen if these events are disabled --
        if not love.window or not love.graphics or not love.event then
            return
        end

        -- if the window is not created, create a default one --
        if not love.graphics.isCreated() or not love.window.isOpen() then
            local success, status = pcall(love.window.setMode, 640, 480)
            if not success or not status then
                return
            end
        end

            -- Reset state.
        if love.mouse then
            love.mouse.setVisible(true)
            love.mouse.setGrabbed(false)
            love.mouse.setRelativeMode(false)
            if love.mouse.isCursorSupported() then
                love.mouse.setCursor()
            end
        end
        if love.joystick then
            -- Stop all joystick vibrations.
            for i,v in ipairs(love.joystick.getJoysticks()) do
                v:setVibration()
            end
        end
        if love.audio then love.audio.stop() end

        love.graphics.reset()
        local fonttitle = love.graphics.newFont(COCONUT_PATH .. "/assets/fonts/fredoka_regular.ttf", 24)
        local font = love.graphics.newFont(COCONUT_PATH .. "/assets/fonts/fredoka_regular.ttf", 16)
        local spritelogo = Coconut.Assets.get(Coconut.Assets.AssetType.IMAGE, "logo")

        love.graphics.setColor(1, 1, 1)

        local trace = debug.traceback()
        local sanitizedmsg = {}
        for char in msg:gmatch(utf8.charpattern) do
            table.insert(sanitizedmsg, char)
        end
        sanitizedmsg = table.concat(sanitizedmsg)
    
        local err = {}
    
        table.insert(err, "[CoconutError]\n")
        table.insert(err, sanitizedmsg)
    
        if #sanitizedmsg ~= #msg then
            table.insert(err, "Invalid UTF-8 string in error message.")
        end
    
        table.insert(err, "\n")
    
        for l in trace:gmatch("(.-)\n") do
            if not l:match("boot.lua") then
                l = l:gsub("stack traceback:", "Traceback\n")
                table.insert(err, l)
            end
        end
    
        local p = table.concat(err, "\n")
    
        p = p:gsub("\t", "")
        p = p:gsub("%[string \"(.-)\"%]", "%1")

        local gradientBG = love.graphics.newGradient("vertical", Coconut.Color.fromInt(0x62361FFF),  Coconut.Color.fromInt(0x402212FF))

        local function render()
            if not love.graphics.isActive() then return end
            love.graphics.clear(0, 0, 0, 1)
            love.graphics.draw(gradientBG, 0, 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            love.graphics.draw(spritelogo, 32, 32, 0, 0.25, 0.25)
            love.graphics.printf("[CoconutError]", fonttitle, 64, 72, love.graphics.getWidth() - 64, "center")
            love.graphics.printf(p, font, 64, 164, love.graphics.getWidth() - 64)
            love.graphics.present()
        end

        local fullErrorText = p
        local function copyToClipboard()
            if not love.system then return end
            love.system.setClipboardText(fullErrorText)
            p = p .. "\nCopied to clipboard!"
        end
    
        if love.system then
            p = p .. "\n\nPress Ctrl+C or tap to copy this error"
        end

        return function()
            love.event.pump()
    
            for e, a, b, c in love.event.poll() do
                if e == "quit" then
                    return 1
                elseif e == "keypressed" and a == "escape" then
                    return 1
                elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
                    copyToClipboard()
                elseif e == "touchpressed" then
                    local name = love.window.getTitle()
                    if #name == 0 or name == "Untitled" then name = "Game" end
                    local buttons = {"OK", "Cancel"}
                    if love.system then
                        buttons[3] = "Copy to clipboard"
                    end
                    local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
                    if pressed == 1 then
                        return 1
                    elseif pressed == 3 then
                        copyToClipboard()
                    end
                end
            end
    
            render()
    
            if love.timer then
                love.timer.sleep(0.1)
            end
        end
    end

    love.quit = function()
        print("[CoconutRuntime] Freed assets from pool")
        Coconut.Assets.resetPool()
    end
end

function Coconut.reset()
    Coconut.initialized = false
    Coconut.init(Coconut.Args)
end

return Coconut