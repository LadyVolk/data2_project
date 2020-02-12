local enemy = require "enemy"
local vec2 = require "CPML.vec2"

local function new()

  local manager ={

    timer = 0,
    cooldown = 2,
  }


  function manager:update(dt)
    self.timer = self.timer + dt

    while self.timer >= self.cooldown do
      self.timer = self.timer - self.cooldown
      self:create_enemy()
    end
  end

  function manager:create_enemy()
    local enemy_pos = vec2(love.math.random(0, WIN_S.x-30),
                  love.math.random(0, WIN_S.y-30))
    local e = enemy(enemy_pos)
    table.insert(ELEMENTS, e)
  end

  return manager

end

return new
