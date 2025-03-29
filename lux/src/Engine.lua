local Color = import 'utils.Color'
local Signal = import 'utils.Signal'

---
--- @class lux.Engine
---
local Engine = {}

--- Color of the background after a frame is rendered ---
Engine.backgroundColor = Color.BLACK    --- @type lux.utils.Color

--- the window width in pixels ---
Engine.width = 640                      --- @type integer

--- the window height in pixels ---
Engine.height = 480                     --- @type integer

--- The time controller ---
Engine.timeScale = 1.0                  --- @type integer

--- Controls whether or not the framerate of the game
--- should match the monitor that the window
--- is currently within
Engine.vsync = false                    --- @type boolean

Engine.onLoad = Signal()                --- @type lux.utils.Signal

Engine.onPreDraw = Signal()             --- @type lux.utils.Signal

Engine.onDraw = Signal()                --- @type lux.utils.Signal

Engine.onPostDraw = Signal()            --- @type lux.utils.Signal

Engine.onUpdate = Signal()              --- @type lux.utils.Signal

Engine.onSceneEnter = Signal()          --- @type lux.utils.Signal

Engine.onSceneLeave = Signal()          --- @type lux.utils.Signal

Engine.onSceneInit = Signal()           --- @type lux.utils.Signal

Engine.onSceneDraw = Signal()           --- @type lux.utils.Signal

Engine.onSceneUpdate = Signal()         --- @type lux.utils.Signal

Engine.onInput = Signal()               --- @type lux.utils.Signal

Engine.onWindowResize = Signal()        --- @type lux.utils.Signal

Engine.onWindowStateChange = Signal()   --- @type lux.utils.Signal

Engine.onQuit = Signal()                --- @type lux.utils.Signal

return Engine