local vec2 = require "CPML.vec2"

local function new(_pos)

  local enemy = {
    id = "enemy",
    pos = _pos,
    size = vec2(30,30),
    color = {r = 1, g = 0, b = 0},
    death = false,
    health = 10,
  }

  function enemy:update(dt)

  end

  function enemy:draw()
    love.graphics.setColor(self.color.r, self.color.g,
    self.color.b)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y,
    self.size.x, self.size.y)
  end

  function enemy:hit(projectile)
    self.health = self.health - projectile.damage
    if self.health <= 0 then
      self.death = true
    end
    projectile.death = true
  end

  return enemy
end

return new
