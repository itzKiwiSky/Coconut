return function(components)
    local self = {}
    self.visible = true
    self.paused = false
    self.parent = nil
    self.children = {}
    self.tags = {}
    self.destroy = false

    local meta = { __index = {} }
    for _, component in ipairs(components) do
        local c
        if type(component) == "string" then table.insert(self.tags, component) else c = component() end

        if c ~= nil then
            for k, v in pairs(c) do
                if type(v) == "function" then
                    meta.__index[k] = v
                else
                    
                    if not self[k] then
                        self[k] = self[k] or v
                    else
                        -- trigger error --
                    end
                end
            end
    
            if type(c.__onMount) == "function" then
                c.__onMount(self)
            end
        end
    end

    setmetatable(self, meta)

    function self:add(obj)
        obj.parent = self
        table.push(self.children, obj)
    end

    function self:destroy()
        self.destroy = true
    end

    return self
end