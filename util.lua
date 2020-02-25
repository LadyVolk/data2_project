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
    active = element.active,
    death = element.death,
    health = element.health,
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

function functs.update_element(soft_element, element)

  element.pos = vec2(soft_element.pos_x, soft_element.pos_y)
  element.direction = vec2(soft_element.dir_x, soft_element.dir_y)
  element.active = soft_element.active
  element.growing = soft_element.growing
  element.death = soft_element.death
  element.active = soft_element.active
  element.health = soft_element.health
end

function functs.check_errors(table_threads)
  while true do
    for i, thread in ipairs(table_threads) do
      thread:getError()
    end
  end
end

function functs.soft_collision(e1, e2)
  if e1.pos_x > e2.pos_x+e2.size_x or e1.pos_x+e1.size_x < e2.pos_x or
     e1.pos_y > e2.pos_y+e2.size_y or e1.pos_y+e1.size_y < e2.pos_y
  then
    return false
  else
    return true
  end
end

return functs
