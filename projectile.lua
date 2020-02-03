local function new(_pos, _direction)

  local projectile = {
    id = "projectile",
    pos = _pos,
    size = {w = 10, h = 10},
    speed = 1000,
    color = {r = 0, g = 1, b = 1},
    direction = _direction,
  }

  function projectile:update(dt)
    self:update_movement(dt)
  end

  function projectile:draw()
    love.graphics.setColor(self.color.r, self.color.g,
    self.color.b)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y,
    self.size.w, self.size.h)
  end

  function projectile:update_movement(dt)
    self.pos = self.pos + self.direction * self.speed * dt
  end
  return projectile
end
return new
