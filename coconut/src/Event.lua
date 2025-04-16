local Signal = import 'utils.Signal'

local Events = {}

function Events.connect(subject, listener)
    _event.hook(subject, listener)
end

return Events