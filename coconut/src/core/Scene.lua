local Color = import 'utils.Color'
local Engine = import 'Engine'
local Camera = import 'core.Camera'

local function null()end

local Scene = class:extend("Scene")

local events = {
    "onSceneLoad",
    "onSceneEnter",
    "onSceneLeave",
    "onSceneUpdate",
    "onSceneObjectAdded",

    "keypressed",
    "keyreleased",
    "mousepressed",
    "mousereleased",
    "mousemoved",
    "mousescrolled",
    "textinput",
    "joystickadded",
    "joystickremoved",
    "joystickpressed",
    "joystickreleased",
    "joystickaxis"
}

local LoveEvents = {

}


function Scene:__construct()
    self.camera = {
        ["root"] = Camera:new(0, 0)
    }
    self.currentCamera = "root"
    self.isDirty = false
    self.meta = {}
    self.meta.background = Color.TRANSPARENT

    --self = table.merge(self, Event:new())
    --print(inspect(Event:new(self)))

    --print(inspect(Event:new()))

    -- how can I call the event class without overriding this class itself?


    self.objects = {}

    --for _, event in ipairs(LoveEvents) do
        --Scene["on" .. event:gsub("^%l", string.upper)] = function()end
    --end
    
    for _, e in ipairs(events) do
        self[e] = null
    end
    --self = table.deepmerge(self, Event:new())

    --print(inspect(self))

    self:onSceneLoad()
end

function Scene:add(obj)
    local objID = #self.objects + 1
    obj.id = objID
    self.objects[#self.objects + 1] = obj
    self.onSceneObjectAdded()
end

function Scene:draw()
    self.camera[self.currentCamera]:start()
        if #self.objects > 0 then
            for k, obj in ipairs(self.objects) do
                if obj.__draw then
                    obj:__draw()
                end
            end
        end
    self.camera[self.currentCamera]:stop()
end

function Scene:update(elapsed)
    self.onSceneUpdate(elapsed)
    if #self.objects > 0 then
        for _, obj in ipairs(self.objects) do
            if obj.__update and not obj.paused and not obj.destroy then
                obj:__update(elapsed)
            end
        end
    end
end

--- Runs a routine to clear every object marked as "destroy"
function Scene:collectDestroyedObjects()
    for _, obj in ipairs(self.objects) do
        if obj.destroy ~= nil and obj.destroy == true then
            table.remove(self.objects, _)
        end
    end
end


--- Clear all objects inside the scene
function Scene:destroyAll()
    for _, obj in ripairs(self.objects) do
        if not obj.dontDestroy then
            table.remove(self.objects, _)
        end
    end
end

local SceneManager = {
    gameScenes = {},
    currentScene = "root",
}

--- @protected
local function drawBGGrid(width, height, cellSize)
    for y = 0, math.floor(height / cellSize), 1 do
        for x = 0, math.floor(width / cellSize), 1 do
            local ogc = { love.graphics.getColor() }
            if (x + y) % 2 == 0 then
                love.graphics.setColor(((x + y) % 2 == 0) and Color.fromInt(0x808080FF) or Color.fromInt(0x414141FF))
            end
            love.graphics.rectangle("fill", x * 32, y * 32, cellSize, cellSize)
            love.graphics.setColor(Color.fromInt(0x414141FF))
        end
    end
end

--- Create a new scene on the scene pool
---@param name string
function SceneManager.newScene(name)
    SceneManager.gameScenes[name] = Scene:new()
    return SceneManager.gameScenes[name] 
end

--- Add the object to the current scene
---@param obj Object
function SceneManager.add(obj)
    SceneManager.gameScenes[SceneManager.currentScene]:add(obj)
end

--- Change the current scene
---@param name string
function SceneManager.switch(name)
    assert(SceneManager.gameScenes[name], "[CoconutRuntimeError] : Scene not found " .. name)
    --print(inspect(SceneManager.gameScenes[SceneManager.currentScene]))
    SceneManager.gameScenes[SceneManager.currentScene]:onSceneLeave()
    SceneManager.gameScenes[SceneManager.currentScene]:destroyAll()

    SceneManager.currentScene = name

    -- reset camera --
    for _, cam in pairs(SceneManager.gameScenes[SceneManager.currentScene].camera) do
        cam:reset()
    end

    SceneManager.gameScenes[SceneManager.currentScene]:onSceneEnter()
end

function SceneManager.draw()
    if SceneManager.gameScenes[SceneManager.currentScene].meta.background[4] <= 0 then
        drawBGGrid(Engine.width, Engine.height, 32)
    else
        love.graphics.setColor(SceneManager.gameScenes[SceneManager.currentScene].meta.background)
        love.graphics.rectangle("fill", 0, 0, Engine.width, Engine.height)
    end
    love.graphics.setColor(1, 1, 1, 1)

    SceneManager.gameScenes[SceneManager.currentScene]:draw()
end

function SceneManager.update(elapsed)
    SceneManager.gameScenes[SceneManager.currentScene]:collectDestroyedObjects()
    SceneManager.gameScenes[SceneManager.currentScene]:update(elapsed)
end

function SceneManager.processEvents(event)
    local eventName = "on" .. event[1]:gsub("^%l", string.upper)
    --print("[CoconutRuntime] Processing event: " .. eventName)
    table.remove(event, 1) -- remove the event name from the table
    if SceneManager.gameScenes[SceneManager.currentScene][eventName] then
        SceneManager.gameScenes[SceneManager.currentScene][eventName](unpack(event))
    end
end

return SceneManager