local vec2 = require "CPML.vec2"

local function new(_pos, _manager)

  local vec_dir = vec2()

  vec2.normalize(vec_dir, vec2(love.math.random()*2-1,
                               love.math.random()*2-1))

  local enemy = {
    manager = _manager,
    id = "enemy",
    pos = _pos,
    size = vec2(20,20),
    color = {r = 1, g = 0, b = 0},
    death = false,
    health = 10,
    --being active
    growing = 0,
    growth_time = 2,
    active = false,
    --movement
    speed = 300,
    direction = vec_dir,
  }

  function enemy:update(dt)
    if self.active == false then
      self.growing = self.growing + dt
      if self.growing >= self.growth_time then
        self.growing = self.growth_time
        self.active = true
      end
    else
      enemy:update_movement(dt)
      enemy:update_logic()
    end
  end

  function enemy:draw()
    love.graphics.setColor(self.color.r, self.color.g,
    self.color.b, self.growing/self.growth_time)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y,
    self.size.x, self.size.y)
  end

  function enemy:hit(projectile)
    self.health = self.health - projectile.damage
    if self.health <= 0 then
      self.death = true
      self.manager.quant = self.manager.quant - 1
    end
    projectile.death = true
  end

  function enemy:update_movement(dt)
    self.pos = self.pos + self.direction * self.speed * dt

    if self.pos.x + self.size.x > WIN_S.x then
      self.pos.x = WIN_S.x - self.size.x
      self.direction.x = -self.direction.x
    elseif self.pos.x < 0 then
      self.pos.x = 0
      self.direction.x = -self.direction.x
    end
    if self.pos.y + self.size.y > WIN_S.y then
      self.pos.y = WIN_S.y - self.size.y
      self.direction.y = -self.direction.y
    elseif self.pos.y < 0 then
      self.pos.y = 0
      self.direction.y = -self.direction.y
    end
  end

  function enemy:update_logic()
    for i = 0, SIMULATION_SIZE do
      --complex things in games enemies would do
    end
  end

  return enemy
end

return new
