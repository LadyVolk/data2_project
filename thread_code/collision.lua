return [[

local debug = ...
local util = require "util"
local channel_receive = love.thread.getChannel("channel_element")
local ret_update = love.thread.getChannel("return_update")

local function atomic_pop(channel)
  local e1 = channel:pop()
  if not e1 then
    return "found_nothing"
  end
  if e1 == "finished" then
    return "finished"
  end
  local e2 = channel:demand()
  return e1, e2
end

local e1, e2
while true do

  e1, e2 = channel_receive:performAtomic(atomic_pop)

  if e1 == "finished" then
    break
  end
  if e1 ~= "found_nothing" then
    collided = util.soft_collision(e1, e2)

    if ((e1.id == "enemy" and e2.id == "projectile" and e1.active) or
    (e2.id == "enemy" and e1.id == "projectile" and e2.active)) and
    collided
    then
      local enemy = e1.id == "enemy" and e1 or e2
      local projectile = e1.id == "projectile" and e1 or e2
      enemy.health = enemy.health - projectile.damage
      if enemy.health <= 0 then
        enemy.death = true
      end
      projectile.death = true

    elseif ((e1.id == "enemy" and e2.id == "player" and e1.active) or
    (e2.id == "enemy" and e1.id == "player" and e2.active)) and
    collided
    then
      local player = e1.id == "player" and e1 or e2
      if not debug then
        player.death = true
      end
    end
    ret_update:push(e1)
    ret_update:push(e2)
  end
end
ret_update:push("finished")
]]
