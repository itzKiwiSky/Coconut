local LPCamera = {}
LPCamera.__index = LPCamera

function LPCamera.new(x, y, zoom, rotation)
    local self = setmetatable({}, LPCamera)

    self.x, self.y = x or 0, y or 0
    self.zoom = zoom or 1
    self.rotation = rotation or 0

    return self
end

--- Attach camera to begin transformation
function LPCamera:start()
    local cx, cy = Dino2D.push.getWidth() / 2, Dino2D.push.getHeight() / 2
    love.graphics.push("all")
    love.graphics.translate(cx, cy)
    love.graphics.scale(self.zoom)
    love.graphics.rotate(self.rotation)
    love.graphics.translate(-self.x, -self.y)
end

--- Detach camera to stop the effect transformation
function LPCamera:stop()
    love.graphics.pop()
end

--- world coordinates to camera coordinates
---@param x number
---@param y number
---@param ox number
---@param oy number
---@param w number
---@param h number 
function LPCamera:cameraCoords(x, y, ox, oy, w, h)
    ox, oy = ox or 0, oy or 0
    w, h = w or love.graphics.getWidth(), h or love.graphics.getHeight()

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
function LPCamera:worldCoords(x, y, ox, oy, w, h)
    ox, oy = ox or 0, oy or 0
    w, h = w or love.graphics.getWidth(), h or love.graphics.getHeight()

    -- x,y = (((x,y) - center) / self.scale):rotated(-self.rot) + (self.x,self.y)
    local c, s = math.cos(-self.rotation), math.sin(-self.rotation)
    x, y = (x - w / 2 - ox) / self.zoom, (y - h / 2 - oy) / self.zoom
    x, y = c * x - s * y, s * x + c * y
    return x + self.x, y + self.y
end

--- Get mouse position based on camera transformation
---@param ox number
---@param oy number
---@param w number
---@param h number
function LPCamera:mousePosition(ox, oy, w, h)
    local mx, my = love.mouse.getPosition()
    return self:worldCoords(mx, my, ox, oy, w, h)
end

--- Set camera zoom
---@param zoom number
function LPCamera:setZoom(zoom)
    self.zoom = zoom
    return self
end

--- Set camera rotation
---@param rotation number
function LPCamera:setRotation(rotation)
    self.rotation = math.rad(rotation)
    return self
end

--- Set camera position
---@param x number
---@param y number
function LPCamera:setCameraPosition(x, y)
    self.x, self.y = x, y
    return self
end

return LPCamera