local LUXASSETS = (...):match('(.-)[^/]+$')

local Font = class:extend("Font")

function Font:__construct(path)
    self.path = path or LUXASSETS .. "/fredoka_regular.ttf"
end

function Font:makeFont(size)
    return love.graphics.newFont(self.path, size or 20)
end


return Font