local Kiwi2D = {}

local KIWI_PATH = (...) .. "."

function import(modname)
    if modname == nil or #modname == 0 then
        return require(KIWI_PATH)
    end
    return require(KIWI_PATH .. "src." .. modname)
end

local fsutil = require(KIWI_PATH .. "FSutil")

local addons = fsutil.scanFolder(KIWI_PATH .. "/addons")
for a = 1, #addons, 1 do
    local ad = addons[a]:gsub(".lua", "")
    require(ad:gsub("/", "%."))
end

Kiwi2D.initialized = false

class = require(KIWI_PATH .. "libraries.classic")
_xml = require(KIWI_PATH .. "libraries.xml")
_json = require(KIWI_PATH .. "libraries.json")
_lume = require(KIWI_PATH .. "libraries.lume")
Kiwi2D.push = require(KIWI_PATH .. "libraries.push")

local fsutil = require(KIWI_PATH .. "FSutil")

local addons = fsutil.scanFolder(KIWI_PATH .. "/addons")
for a = 1, #addons, 1 do
    local ad = addons[a]:gsub(".lua", "")
    require(ad:gsub("/", "%."))
end

-- API --
Kiwi2D.Scene = import 'core.Scene'

Kiwi2D.Event = import 'Events'


function Kiwi2D.init(config)
    assert(Kiwi2D.initialized == true, "[Kiwi2DError] : Kiwi2D is already initialized")

    -- load configs --
    config = config or {}
    local conf = {
        width = config.width or 640,
        height = config.height or 480,
        vsync = config.vsync or false,
        title = config.title or "Powered with Kiwi2D",
        scene = config.scene or "root",
        resizable = config.resizable or true,
        fullscreen = config.fullscreen or false,
        packageid = config.packageid or "Kiwi2D.game",
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

    -- load components --
    local components = fsutil.scanFolder(KIWI_PATH .. "/src/Components")
    for c = 1, #components, 1 do
        local comp = components[c]:gsub(".lua", "")
        Kiwi2D.Components[components[c]:match("[^/]+$"):gsub(".lua", "")] = require(comp:gsub("/", "%."))
    end

    local mainCanvas = love.graphics.newCanvas(conf.width, conf.height)
    mainCanvas:setFilter(
        conf.antialiasing and "linear" or "nearest",
        conf.antialiasing and "linear" or "nearest"
    )

    Kiwi2D.push.setupScreen(conf.width, conf.height, { upscale = conf.antialiasing and "normal" or "pixel-perfect", canvas = true })
    
    Kiwi2D.engine.width = Kiwi2D.push.getWidth()
    Kiwi2D.engine.height = Kiwi2D.push.getHeight()

    Kiwi2D.initialized = true
end

return Kiwi2D