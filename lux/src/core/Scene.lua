local Color = import 'utils.Color'
local Engine = import 'Engine'
local Camera = import 'core.Camera'

local function null()end

---@class lux.core.Scene
local Scene = {
    gameScenes = {},
    currentScene = "root",
}

Scene.camera = Camera(0, 0) ---@type lux.core.Camera

--- @protected
local function add(obj)
    print("added")
    -- add the object and check if have the Z component --
    if obj.z then
        table.insert(Scene.gameScenes[Scene.currentScene].objects, obj)
        table.sort(Scene.gameScenes[Scene.currentScene].objects, function(a, b)
            return a.z < a.b
        end)
        return
    end
    table.insert(Scene.gameScenes[Scene.currentScene].objects, obj)
    print(inspect(Scene.gameScenes))
end

--- @protected
local function drawBGGrid(width, height, cellSize)
    for y = 0, math.floor(height), 1 do
        for x = 0, math.floor(width), 1 do
            local ogc = { love.graphics.getColor() }
            if (x + y) % 2 == 0 then
                love.graphics.setColor(((x + y) % 2 == 0) and Color.fromInt(0x808080FF) or Color.fromInt(0x414141FF))
            end
            love.graphics.rectangle("fill", x * 32, y * 32, cellSize, cellSize)
            love.graphics.setColor(Color.fromInt(0x414141FF))
        end
    end
end

--- @interface  Scene functions
local IScene = {
    onLoad = null,
    onDraw = null,
    onUpdate = null,

    add = add
}

--- Create a new scene in the game context
---@param name string
---@param def string | function
function Scene.newScene(name, def)
    local scenedef = {
        def = null,
        meta = {},
        objects = {},
    }

    scenedef.meta.background = Color.TRANSPARENT

    if type(def) == "string" then
        local fn, err = pcall(love.filesystem.load, def)
        assert(err == nil, "[Lux2DError] : Error found while loading script: " .. err)
        local fndata, err = pcall(fn)
        assert(err == nil, "[Lux2DError] : Uncaught error found while loading a script]")

        scenedef.def = fndata

        Scene.gameScenes[name] = scenedef
        return
    end
    scenedef.def = def
    Scene.gameScenes[name] = scenedef
end

function Scene.switchScene(name)
    assert(Scene.gameScenes[name], "[Lux2DError] : Scene not found " .. name)
    Engine.onSceneEnter:trigger(name)
    for _, obj in ripairs(Scene.gameScenes[name]) do
        if not obj.stay then
            table.remove(obj, _)
        end
    end
    Scene.currentScene = name
    -- reset camera --
    Scene.camera:reset()
    Engine.onSceneInit:trigger(name)
    
    Scene.gameScenes[name].def(IScene)
    if IScene.onLoad then
        IScene.onLoad()
    end
end

function Scene.draw()
    if Scene.gameScenes[Scene.currentScene].meta.background[4] < 0 then
        --love.graphics.rectangle("fill")
        drawBGGrid(Engine.width, Engine.height, 32)
    else

    end
    if #Scene.gameScenes[Scene.currentScene].objects > 0 then
        Scene.camera:start()
        for _, obj in ipairs(Scene.gameScenes[Scene.currentScene].objects) do
            table.sort(Scene.gameScenes[Scene.currentScene].objects, function(a, b)
                if a.z and b.z then return a.z < a.b end
            end)
            if obj.__draw and obj.visible then
                obj:__draw()
            end
            if obj.children then
                if #obj.children > 0 then
                    _lume.each(obj.children, function(c)
                        if c.__draw and (obj.visible or c.visible) then
                            c:__draw()
                        end
                    end)
                end
            end
        end
        Scene.camera:stop()
    end
end

function Scene.update(elapsed)
    for _, obj in ipairs(Scene.gameScenes[Scene.currentScene].objects) do
        if obj.__update and not obj.paused then
            obj:__update()
        end
    end
end

return Scene