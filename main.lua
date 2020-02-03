WIN_S = {w = 1000, h = 800}
local vec2 = require "CPML.vec2"
function love.load()
  love.window.setMode(WIN_S.w, WIN_S.h)
  ELEMENTS = {
    require("player")(vec2(300, 300))
  }

end

function love.update(dt)
  for i, element in ipairs(ELEMENTS) do
    element:update(dt)
  end
end

function love.draw()
  for i, element in ipairs(ELEMENTS) do
    element:draw()
  end

end

function love.mousepressed(x, y, button, isTouch)
  for i, element in ipairs(ELEMENTS) do
    if element.id == "player" then
      element:mousepressed(button)
    end
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end
end
