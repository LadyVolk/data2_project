local vec2 = require "CPML.vec2"

local function new(_pos)
  local player = {
    pos = _pos,
    size = {w = 50, h = 50},
    speed = 500,
    color = {r = 0.5, g = 1, b = 1},
  }

  function player:draw()
    love.graphics.setColor(self.color.r, self.color.g,
    self.color.b)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y,
    self.size.w, self.size.h)

  end

  function player:update(dt)
    player:update_movement(dt)
  end

  function player:update_movement(dt)
    local mov_vec = vec2(0, 0)
    if love.keyboard.isDown("w") then
      mov_vec = mov_vec - vec2(0, 1)
    end
    if love.keyboard.isDown("a") then
      mov_vec = mov_vec - vec2(1, 0)
    end
    if love.keyboard.isDown("s") then
      mov_vec = mov_vec + vec2(0, 1)
    end
    if love.keyboard.isDown("d") then
      mov_vec = mov_vec + vec2(1, 0)
    end

    local normalized = vec2()
    vec2.normalize(normalized, mov_vec)
    self.pos = self.pos + mov_vec * self.speed * dt
  end

  return player
end

return new
