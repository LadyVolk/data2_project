local vec2 = require "CPML.vec2"
function love.load()
  player = require("player")(vec2(300, 300))
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
