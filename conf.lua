function love.conf(w)
    w.console = not love.filesystem.isFused()
    w.externalstorage = true
end