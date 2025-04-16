local Color = import 'utils.Color'
local Signal = import 'utils.Signal'

---
--- @class kiwi.Engine
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

return Engine