local vec2 = import 'Math.Vec2'
local assets = import 'utils.AssetPool'

local AudioGroup = class:extend("AudioChannel")

---@class Coconut.utils.AudioMixer.AudioChannel
---@field volume number
---@field pitch number
---@field position Vec2
---@field private assetname string
---@field private source love.audio.Source
function AudioChannel:__construct()
    self.volume = 0.75
    self.pitch = 1
    self.position = vec2.ZERO()
    self.assetName = "" 
    self.source = nil
    self.loadType = assets.AudioLoadType.STREAM
end

function AudioChannel:useAsset(name)
    self.assetName = name
    self.source = assets.get(assets.AssetType.AUDIO, self.assetName, {})
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

---@private
function AudioMixer.update()
    
end

return AudioMixer