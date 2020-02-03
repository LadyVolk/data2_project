local vec2 = require "CPML.vec2"
function love.load()
  player = require("player")(vec2(300, 300))
  projectile = require("projectile")(vec2(200, 200),
                        vec2(1, 0))
end

function love.update(dt)
  player:update(dt)
  projectile:update(dt)
end

function love.draw()
  player:draw()
  projectile:draw()
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end
end
