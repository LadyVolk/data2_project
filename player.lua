local vec2 = require "CPML.vec2"
local projectile = require("projectile")
local function new(_pos)
  local player = {
    id = "player",
    pos = _pos,
    size = {w = 50, h = 50},
    speed = 500,
    color = {r = 0.5, g = 1, b = 1},
    death = false,
  }

  function player:draw()
    love.graphics.setColor(self.color.r, self.color.g,
    self.color.b)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y,
    self.size.w, self.size.h)

  end

  function player:update(dt)
    self:update_movement(dt)
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

    --keep player inside window
    if self.pos.x + self.size.w > WIN_S.w then
      self.pos.x = WIN_S.w - self.size.w
    elseif self.pos.x < 0 then
      self.pos.x = 0
    end
    if self.pos.y + self.size.h > WIN_S.h then
      self.pos.y = WIN_S.h - self.size.h
    elseif self.pos.y < 0 then
      self.pos.y = 0
    end
  end

  function player:mousepressed(button)
    self:shoot()
  end

  function player:shoot()
    local vec_dir = vec2()
    vec2.normalize(vec_dir, vec2(love.mouse.getPosition())-self.pos)
    local tiro = projectile(vec2(self.pos.x, self.pos.y), vec_dir)
    table.insert(ELEMENTS, tiro)
  end

  return player
end

return new
