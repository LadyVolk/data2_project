local player = {
  pos = { x = 300, y = 300},
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
  if love.keyboard.isDown("w") then
    self.pos.y = self.pos.y - self.speed * dt
  end
  if love.keyboard.isDown("a") then
    self.pos.x = self.pos.x - self.speed * dt
  end
  if love.keyboard.isDown("s") then
    self.pos.y = self.pos.y + self.speed * dt
  end
  if love.keyboard.isDown("d") then
    self.pos.x = self.pos.x + self.speed * dt
  end
end

return player
