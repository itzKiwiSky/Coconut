local coconut = require 'coconut'
local fsutil = require 'tests.Libraries.FSUtil'
local lust = nil
coconut.init({debug = true})

-- run the tests and close itself
if love.arg.parseGameArguments(arg)[1] == "--test" then
    lust = require 'tests.Libraries.lust'

    local tests = fsutil.scanFolder("tests/specs")

    if #tests <= 0 then
        print("[LOVE] No tests to run")
        love.event.quit()
    end

    for _, test in ipairs(tests) do
        local t = require((test:gsub("/", ".")):gsub("%.lua", ""))
        t({
            lust = lust,
            coconut = coconut
        })
    end

    love.event.quit()

    return
end

-- demo showcase stuff --
local demospaths = fsutil.scanFolder("demos")
local demos = {}
local currentDemo = 1

for _, demofile in ipairs(demospaths) do
    local file = require((demofile:gsub("/", ".")):gsub("%.lua", ""))
    table.insert(demos, file)
end

demos[currentDemo](coconut)
local canChangeDemo = false
local coconutKeyPressed = love.keypressed

function love.keypressed(k)
    if coconutKeyPressed then
        coconutKeyPressed(k)
    end
    if k == "pageup" then
        if currentDemo < #demos then
            currentDemo = currentDemo + 1
            canChangeDemo = true
        end
    end
    if k == "pagedown" then
        if currentDemo > 1 then
            currentDemo = currentDemo - 1
            canChangeDemo = true
        end
    end

    if canChangeDemo then
        coconut.reset()
        demos[currentDemo](coconut)
        canChangeDemo = false
    end
end