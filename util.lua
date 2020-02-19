local vec2 = require "CPML.vec2"
local functs = {}

function functs.collision(e1, e2)
  if e1.pos.x > e2.pos.x+e2.size.x or e1.pos.x+e1.size.x < e2.pos.x or
     e1.pos.y > e2.pos.y+e2.size.y or e1.pos.y+e1.size.y < e2.pos.y
  then
    return false
  else
    return true
  end
end

--create element that can be passed through channels
function functs.create_soft(element, index_)
  local soft ={
    id = element.id,
    active = element.active,
    growing = element.growing,
    growth_time = element.growth_time,
    pos_x = element.pos.x,
    pos_y = element.pos.y,
    dir_x = element.direction.x,
    dir_y = element.direction.y,
    speed = element.speed,
    size_x = element.size.x,
    size_y = element.size.y,
    --position of element on table ELEMENTS
    index = index_,
  }
  return soft
end

function functs.update_enemy(soft_enemy, enemy)

  enemy.pos = vec2(soft_enemy.pos_x, soft_enemy.pos_y)
  enemy.direction = vec2(soft_enemy.dir_x, soft_enemy.dir_y)
  enemy.active = soft_enemy.active
  enemy.growing = soft_enemy.growing

end

return functs
