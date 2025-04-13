
---
--- @class loveplay.utils.Signal 
---
local Signal = class:extend("Signal")

function Signal:__construct()
    self.connected = {}
    self.connectedOnce = {}
    self.cancelled = {}
end

---
--- Connects a listener function to this signal.
---
--- @param  listener  function  The listener to connect to this signal.
--- @param  priority  integer?  The priority of the listener. Lower numbers are called first.
--- @param  once      boolean?  Whether or not the listener should only be called once.
---
function Signal:connect(listener, priority, once)
    if type(listener) ~= "function" or table.contains(self.connected, listener) then
        return
    end

    if priority then
        table.insert(self.connected, priority, listener)
    else
        table.insert(self.connected, listener)
    end
    
    if once  then
        table.insert(self.connectedOnce, listener)
    end
end

---
--- Disconnects a listener function from this signal.
---
--- @param  listener  function  The listener to disconnect from this signal.
---
function Signal:disconnect(listener)
    if type(listener) ~= "function" or not table.contains(self.connected, listener) then
        return
    end
    if tblContains(self.connectedOnce, listener) then
        table.remove(self.connectedOnce, listener)
    end
    table.remove(self.connected, listener)
end

---
--- Emits/calls each listener functions connected
--- to this signal.
---
--- @param  ...  vararg  The parameters to call on each function.
---
function Signal:trigger(...)
    self.cancelled = false
    for _, func in ipairs(self.connected) do
        if self.cancelled then
            break
        end
        func(...)
    end
    for _, value in ipairs(self.connectedOnce) do
        self:disconnect(value)
    end
end

---
--- Cancels all listener functions from this signal.
---
function Signal:cancel()
    self.cancelled = true
end

---
--- Removes all listener functions from this signal.
---
function Signal:reset()
    self.connected = {}
    self.connectedOnce = {}
end

return Signal