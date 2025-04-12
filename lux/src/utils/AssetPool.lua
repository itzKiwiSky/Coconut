local font = import 'GFX.Font'

local AssetPool = {}
AssetPool.audios = {}
AssetPool.fonts = {
    cache = {},
    paths = {}
}
AssetPool.images = {}
AssetPool.shaders = {}

AssetPool.AudioLoadType = {
    ["STATIC"] = "static",
    ["STREAM"] = "stream"
}

AssetPool.AssetType = {
    AUDIO = "audios",
    FONT = "fonts",
    IMAGE = "images",
    SHADER = "shaders"
}

function AssetPool.get(type, tag, args)
    args = args or {
        fontsize = 20,
        sourcetype = AssetPool.AudioLoadType.STATIC
    }

    return switch(type, {
        ["audios"] = function()
            return AssetPool.audios[tag .. "_" .. args.sourcetype]
        end,
        ["fonts"] = function()
            if AssetPool.fonts.paths[tag] then
                if not AssetPool.fonts.cache[tag .. "-" .. args.fontsize] then
                    AssetPool.fonts.cache[tag .. "-" .. args.fontsize] = AssetPool.fonts.paths[tag]:makeFont(args.fontsize)
                    return AssetPool.fonts.cache[tag .. "-" .. args.fontsize]
                end
            end
        end,
        ["images"] = function()
            if AssetPool.images[tag] then
                return AssetPool.images[tag]
            end
        end
    })
end

function AssetPool.addImage(tag, source)
    AssetPool.images[tag] = love.graphics.newImage(source)
end

function AssetPool.addAudio(tag, source, type)
    AssetPool.audios[tag .. "_" .. AssetPool.AudioLoadType[type]] = love.audio.newSource(source, AssetPool.AudioLoadType[type] or "static")
end

function AssetPool.addFont(tag, source)
    AssetPool.fonts.paths[tag] = font:new(source)
end

return AssetPool