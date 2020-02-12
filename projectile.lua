local vec2 = require "CPML.vec2"

local function new(_pos, _direction)

  local projectile = {
    id = "projectile",
    pos = _pos,
    size = vec2(15, 15),
    speed = 1000,
    color = {r = 0, g = 1, b = 1},
    direction = _direction,
    death = false,
    damage = 5,
  }

  function projectile:update(dt)
    self:update_movement(dt)
  end

  function projectile:draw()
    love.graphics.setColor(self.color.r, self.color.g,
    self.color.b)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y,
    self.size.x, self.size.y)
  end

  function projectile:update_movement(dt)
    self.pos = self.pos + self.direction * self.speed * dt

    --check if shoot is outside window
    if self.pos.x < -self.size.x or self.pos.x > WIN_S.x or
       self.pos.y < -self.size.y or self.pos.y > WIN_S.y
    then
      self.death = true
    end
  end


  return projectile
end
return new
