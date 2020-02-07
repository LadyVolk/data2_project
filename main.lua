local vec2 = require "CPML.vec2"
local util = require "util"

WIN_S = vec2(1000, 800)

function love.load()
  love.window.setMode(WIN_S.x, WIN_S.y)
  ELEMENTS = {
    require("player")(vec2(300, 300))
  }

end

function love.update(dt)
  for i, element in ipairs(ELEMENTS) do
    element:update(dt)
  end
  for i, element in ipairs(ELEMENTS) do
    for i2, element2 in ipairs(ELEMENTS) do
      if element ~= element2 then
        if element.id == "player" and element2.id == "enemy" then
          if util.collision(element, element2) then
            element:hit(element2)
          end
        end
        if element.id == "projectile" and element2.id == "enemy"
           and not element.death and not element2.death
        then
          if util.collision(element, element2) then
            element2:hit(element)
          end
        end
      end
    end
  end
  for i = #ELEMENTS, 1, -1 do
    if ELEMENTS[i].death then
      table.remove(ELEMENTS, i)
    end
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
  if button == 2 then
    table.insert(ELEMENTS, require ("enemy")(vec2(x, y)))
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end
  if key == "f1" then
    print("number of elements: "..#ELEMENTS)
  end
end
