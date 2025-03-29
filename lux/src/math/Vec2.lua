-- class based version of 'hump.vector-light'
local sqrt, cos, sin, atan2 = math.sqrt, math.cos, math.sin, math.atan2

local Vec2 = class:extend("Vec2")

function Vec2:new(x, y)
    self.epsilon = 1e-6
    if type(x) == "table" and y == nil then
        self.x = x[1] or x.x or 0
        self.y = y[2] or x.y or 0
    elseif x ~= nil and y == nil then
        self.x = x
        self.y = x
    else
        self.x = x
        self.y = y
    end
end

---@ protected
local function isVector(v)
    return type(v) == 'table' and type(v.x) == 'number' and type(v.y) == 'number'
end

function Vec2.ZERO()
    return Vec2(0, 0)
end

function Vec2.ONE()
    return Vec2(1, 1)
end

function Vec2.LEFT()
    return Vec2(-1, 0)
end

function Vec2.RIGHT()
    return Vec2(1, 0)
end

function Vec2.UP()
    return Vec2(0, -1)
end

function Vec2.DOWN()
    return Vec2(0, 1)
end

function Vec2:clone(vec)
    return Vec2(vec:unpack())
end

function Vec2:unpack()
    return self.x, self.y
end

function Vec2.__tostring(v)
    return string.format("Vec2(%.2f, %.2f)", v.x, v.y)
end

---------------------------------------------------------------

function Vec2:add(vec)
    self.x, self.y = self.x + vec.x, self.y + vec.y
    return Vec2.new(self.x + vec.x, self.y + vec.y)
end

function Vec2:sub(vec)
    self.x, self.y = self.x - vec.x, self.y - vec.y
    return Vec2.new(self.x - vec.x, self.y - vec.y)
end


function Vec2:mul(scalar)
    self.x, self.y = self.x * scalar, self.y * scalar
    return Vec2.new(self.x * scalar, self.y * scalar)
end

function Vec2:div(scalar)
    self.x, self.y = self.x / scalar, self.y / scalar
    return Vec2.new(self.x / scalar, self.y / scalar)
end

function Vec2:dot(vec)
    return self.x * vec.x + self.y * vec.y
end

function Vec2:length()
    return math.sqrt(self.x^2 + self.y^2)
end

function Vec2:normalize()
    local len = self:length()
    return len > 0 and self:div(len) or Vec2.ZERO
end

function Vec2:rotated(phi)
    local c, s = cos(phi), sin(phi)
    return Vec2.new(c * self.x - s * self.y, s * self.x + c * self.y)
end

function Vec2:perpendicular()
    return Vec2.new(-self.y, self.x)
end

function Vec2:eq(v)
    return math.abs(self.x - v.x) < self.epsilon and math.abs(self.y - v.y) < self.epsilon
end

function Vec2:lt(v)
    return self.x < v.x and self.y < v.y
end

function Vec2:gt(v)
    return self.x > v.x and self.y > v.y
end

function Vec2:le(v)
    return self.x <= v.x and self.y <= v.y
end

function Vec2:ge(v)
    return self.x >= v.x and self.y >= v.y
end

return Vec2