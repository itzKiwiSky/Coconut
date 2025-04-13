local Color = import 'utils.Color'
local Signal = import 'utils.Signal'

---
--- @class lux.Events
---
local Events = {}

--- Color of the background after a frame is rendered ---
Events.backgroundColor = Color.BLACK    --- @type lux.utils.Color

--- The time controller ---
Events.timeScale = 1.0                  --- @type integer

Events.onLoad = Signal:new()                --- @type lux.utils.Signal

Events.onDraw = Signal:new()                --- @type lux.utils.Signal

Events.onUpdate = Signal:new()             --- @type lux.utils.Signal

Events.onSceneEnter = Signal:new()         --- @type lux.utils.Signal

Events.onSceneLeave = Signal:new()         --- @type lux.utils.Signal

Events.onSceneInit = Signal:new()          --- @type lux.utils.Signal

Events.onSceneDraw = Signal:new()          --- @type lux.utils.Signal

Events.onSceneUpdate = Signal:new()        --- @type lux.utils.Signal

Events.onKeyDown = Signal:new()

Events.onKeyUp = Signal:new()

Events.onWindowResize = Signal:new()       --- @type lux.utils.Signal

Events.onWindowStateChange = Signal:new()  --- @type lux.utils.Signal

Events.onQuit = Signal:new()               --- @type lux.utils.Signal

return Events