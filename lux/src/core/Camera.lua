local Engine = import 'Engine'  ---@type lux.Engine

--- @class lux.core.Camera
local Camera = class:extend("Camera")
function Camera:new(x, y, zoom, rotation)
    Camera.super.new(self, x, y, zoom, rotation)
    self.x = x or Engine.width / 2
    self.y = y or Engine.height / 2
    self.zoom = zoom or 1
    self.rotation = rotation or 0
end

--- Reset the camera to a default state
function Camera:reset()
    self.x = Engine.width / 2
    self.y = Engine.height / 2
    self.zoom = 1
    self.rotation = 0
end

--- Attach camera to begin transformation
function Camera:start()
    local cx, cy = Engine.width / 2, Engine.height / 2
    love.graphics.push("all")
    love.graphics.translate(cx, cy)
    love.graphics.scale(self.zoom)
    love.graphics.rotate(math.rad(self.rotation))
    love.graphics.translate(-self.x, -self.y)
end

--- Detach camera to stop the effect transformation
function Camera:stop()
    love.graphics.pop()
end

--- world coordinates to camera coordinates
---@param x number
---@param y number
---@param ox number
---@param oy number
---@param w number
---@param h number 
function Camera:cameraCoords(x, y)
    local ox, oy = 0, 0
    local w, h = Engine.width, Engine.height

    local c, s = math.cos(self.rotation), math.sin(self.rotation)
    x, y = x - self.x, y - self.y
    x, y = c * x - s * y, s * x + c * y
    return x * self.zoom + w / 2 + ox, y * self.zoom + h / 2 + oy
end

---  camera coordinates to world coordinates
---@param x number
---@param y number
---@param ox number
---@param oy number
---@param w number
---@param h number
function Camera:worldCoords(x, y)
    local ox, oy =  0, 0
    local w, h = Engine.width, Engine.height

    -- x,y = (((x,y) - center) / self.scale):rotated(-self.rot) + (self.x,self.y)
    local c, s = math.cos(-self.rotation), math.sin(-self.rotation)
    x, y = (x - w / 2 - ox) / self.zoom, (y - h / 2 - oy) / self.zoom
    x, y = c * x - s * y, s * x + c * y
    return x + self.x, y + self.y
end

--- Get mouse position based on camera transformation
--- @return number, number
function Camera:mousePosition()
    local mx, my = love.mouse.getPosition()
    return self:worldCoords(mx, my)
end

--- Set camera zoom
---@param zoom number
function Camera:setZoom(zoom)
    self.zoom = zoom
    return self
end

--- Set camera rotation
---@param rotation number
function Camera:setRotation(rotation)
    self.rotation = rotation
    return self
end

--- Set camera position
---@param x number
---@param y number
function Camera:setCameraPosition(x, y)
    self.x, self.y = x, y
    return self
end

return Camera