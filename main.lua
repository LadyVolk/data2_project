function love.load()
  player = require "player"
end

function love.update(dt)
  player:update(dt)
end

function love.draw()
  player:draw()
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end
end
