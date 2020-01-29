local player = {
  pos = { x = 300, y = 300},
  size = {w = 50, h = 50},
  speed = 50,
  color = {r = 0.5, g = 1, b = 1},

}

function player:draw()
  love.graphics.setColor(self.color.r, self.color.g,
                          self.color.b)
  love.graphics.rectangle("fill", self.pos.x, self.pos.y,
                          self.size.w, self.size.h)
end

function player.update()
end

return player
