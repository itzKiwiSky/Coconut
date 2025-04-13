local font = import 'GFX.Font'

local AssetPool = {}
AssetPool.audios = {}
AssetPool.fonts = {
    cache = {},
    paths = {}
}
AssetPool.images = {}
AssetPool.shaders = {}
AssetPool.data = {
    binary = {},
    text = {},
}

AssetPool.AudioLoadType = {
    ["STATIC"] = "static",
    ["STREAM"] = "stream"
}

AssetPool.AssetType = {
    AUDIO = "audios",
    FONT = "fonts",
    IMAGE = "images",
    SHADER = "shaders",
    DATA = "data"
}

AssetPool.DataType = {
    TEXT = "text",
    BINARY = "binary",
}

function AssetPool.get(type, tag, args)
    args = args or {
        fontsize = 20,
        sourcetype = AssetPool.AudioLoadType.STATIC,
        datatype = AssetPool.DataType.TEXT,
    }

    return switch(type, {
        [AssetPool.AssetType.AUDIO] = function()
            return AssetPool.audios[tag .. "_" .. args.sourcetype]
        end,
        [AssetPool.AssetType.FONT] = function()
            if AssetPool.fonts.paths[tag] then
                if not AssetPool.fonts.cache[tag .. "-" .. args.fontsize] then
                    AssetPool.fonts.cache[tag .. "-" .. args.fontsize] = AssetPool.fonts.paths[tag]:makeFont(args.fontsize)
                    return AssetPool.fonts.cache[tag .. "-" .. args.fontsize]
                end
            end
        end,
        [AssetPool.AssetType.IMAGE] = function()
            if AssetPool.images[tag] then
                return AssetPool.images[tag]
            end
        end,
        [AssetPool.AssetType.DATA] = function()
            if AssetPool.data[args.datatype] then
                if AssetPool.data[args.datatype][tag] then
                    return AssetPool.data[args.datatype][tag]
                end
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

function AssetPool.addData(tag, data)
    
end

return AssetPool