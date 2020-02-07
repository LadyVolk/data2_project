local function new(_pos)

  local enemy = {
    id = "enemy",
    pos = _pos,
    size = {w = 30, h = 30},
    color = {r = 1, g = 0, b = 0},
    death = false,
  }

  function enemy:update(dt)

  end

  function enemy:draw()
    love.graphics.setColor(self.color.r, self.color.g,
    self.color.b)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y,
    self.size.w, self.size.h)
  end

  return enemy
end

return new
