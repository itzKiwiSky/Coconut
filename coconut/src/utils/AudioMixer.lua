local AudioChannel = class:extend("AudioChannel")

function AudioChannel:__construct()

end

---@class Coconut.utils.AudioMixer
local AudioMixer = {
    groupid = "master",
    channels = {
        ["master"] = AudioChannel:new()
    },
    default = {
        volume = 0.75,
        pitch = 1,
    }
}

function AudioMixer.newChannel(name)
    
end

return AudioMixer