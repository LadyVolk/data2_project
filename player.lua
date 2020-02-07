local vec2 = require "CPML.vec2"
local projectile = require("projectile")

local function new(_pos)
  local player = {
    id = "player",
    pos = _pos,
    size = vec2(50, 50),
    speed = 500,
    color = {r = 0.5, g = 1, b = 1},
    death = false,
  }

  function player:draw()
    love.graphics.setColor(self.color.r, self.color.g,
    self.color.b)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y,
    self.size.x, self.size.y)

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
    if self.pos.x + self.size.x > WIN_S.x then
      self.pos.x = WIN_S.x - self.size.x
    elseif self.pos.x < 0 then
      self.pos.x = 0
    end
    if self.pos.y + self.size.y > WIN_S.y then
      self.pos.y = WIN_S.y - self.size.y
    elseif self.pos.y < 0 then
      self.pos.y = 0
    end
  end

  function player:mousepressed(button)
    if button == 1 then
      self:shoot()
    end
  end

  function player:shoot()
    local vec_dir = vec2()
    local center = self.pos+self.size/2
    vec2.normalize(vec_dir, vec2(love.mouse.getPosition())-center)
    local tiro = projectile(center, vec_dir)
    table.insert(ELEMENTS, tiro)
  end

  function player:hit(enemy)
    self.death = true
  end

  return player
end

return new
