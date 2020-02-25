local vec2 = require "CPML.vec2"
local util = require "util"
--local functions
local update_elements
local check_collisions
--local variables
local manager
local font_fps

SIMULATION_SIZE = 0
WIN_S = vec2(1000, 800)
DEBUG = true
COLLISION_T = true
ENEMY_LOGIC = true

function love.load()
  love.window.setMode(WIN_S.x, WIN_S.y)
  ELEMENTS = {
    require("player")(vec2(300, 300))
  }
  manager = require("enemy_manager")()

  font_fps = love.graphics.newFont(20)

  MAX_THREADS = love.system.getProcessorCount()

  THREADS = 1
end

function love.update(dt)
  manager:update(dt)

  update_elements(dt)

  check_collisions()

  for i = #ELEMENTS, 1, -1 do
    if ELEMENTS[i].death then
      if ELEMENTS[i].id == "enemy" then
        manager.quant = manager.quant - 1
      end
        table.remove(ELEMENTS, i)
    end
  end
end

function love.draw()
  for i, element in ipairs(ELEMENTS) do
    element:draw()
  end

  --draw fps
  love.graphics.setFont(font_fps)
  love.graphics.setColor(0, 1, 0)
  love.graphics.print("fps: "..love.timer.getFPS(), 5, 0)
  love.graphics.print("simulation size: "..SIMULATION_SIZE, 5, 20)
  love.graphics.print("number of threads: "..THREADS..
                      " / "..MAX_THREADS, 5, 40)
  local text = COLLISION_T and "" or "not"

  love.graphics.print("collision is "..text.." using threads", 5, 60)
  text = ENEMY_LOGIC and "" or "not"
  love.graphics.print("enemy logic is "..text.." using threads", 5, 80)

  love.graphics.setColor(0, 1, 1)
  love.graphics.print("CONTROLS", 5, WIN_S.y-150)
  love.graphics.print("use mouse to shoot", 5, WIN_S.y-130)
  love.graphics.print("'WASD' to control player", 5, WIN_S.y-110)
  love.graphics.print("'R/T' to change number of threads", 5, WIN_S.y-90)
  love.graphics.print("'Q/E' to change simulation size", 5, WIN_S.y-70)
  love.graphics.print("'f1' to toggle collision with threads", 5, WIN_S.y-50)
  love.graphics.print("'f2' to toggle enemy logic with threads", 5, WIN_S.y-30)
end

function love.mousepressed(x, y, button, isTouch)
  for i, element in ipairs(ELEMENTS) do
    if element.id == "player" then
      element:mousepressed(button)
    end
  end
  if button == 2 then
    manager:create_enemy()
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()

  --keys pressing for simulation chnages
elseif key == "q" and SIMULATION_SIZE > 0 then
    SIMULATION_SIZE = SIMULATION_SIZE - 1000000
  elseif key == "e" then
    SIMULATION_SIZE = SIMULATION_SIZE + 1000000

  --keys for changing number of THREADS
  elseif key == "r" and THREADS > 1 then
    THREADS = THREADS - 1
  elseif key == "t" and THREADS < MAX_THREADS then
    THREADS = THREADS + 1

  --switch debug mode
  elseif key == "f3" then
    DEBUG = not DEBUG

  --toggle colission use by thread
  elseif key == "f1" then
      COLLISION_T = not COLLISION_T
  --toggle enemy logic use by thread
  elseif key == "f2" then
    ENEMY_LOGIC = not ENEMY_LOGIC
  end
end

function check_collisions()
  --single thread collision
  if THREADS == 1 or not COLLISION_T then
    for i, element in ipairs(ELEMENTS) do
      for i2, element2 in ipairs(ELEMENTS) do
        if element ~= element2 then
          if element.id == "player" and element2.id == "enemy" and
          element2.active
          then
            if util.collision(element, element2) then
              element:hit(element2)
            end
          end
          if element.id == "projectile" and element2.id == "enemy"
          and not element.death and not element2.death and
          element2.active
          then
            if util.collision(element, element2) then
              element2:hit(element)
            end
          end
        end
      end
    end
    --multi thread collision
  else
    local table_threads = {}

    for i = 1, THREADS - 1 do
      table.insert(table_threads, love.thread.newThread(require("thread_code.collision")))
    end

    for i, thread in ipairs(table_threads) do
      thread:start(DEBUG)
    end

    local function push_elements(channel, e1, e2)
      channel:push(e1)
      channel:push(e2)
    end
    local c_element = love.thread.getChannel("channel_element")
    for i = 1, #ELEMENTS do
      local e1 = util.create_soft(ELEMENTS[i], i)
      for j = i + 1, #ELEMENTS do
        local e2 = util.create_soft(ELEMENTS[j], j)
        c_element:performAtomic(push_elements, e1, e2)
      end
    end
    --finish THREADS
    for i, thread in ipairs(table_threads) do
      c_element:push("finished")
    end
    --update elements
    local retorno = love.thread.getChannel("return_update")
    local counter = 0
    while counter < THREADS - 1 do
      local e = retorno:demand()
      if e == "finished" then
        counter = counter + 1
      else
        util.update_element(e, ELEMENTS[e.index])
      end
    end
    for i, thread in ipairs(table_threads) do
      thread:wait()
    end
  end
end

function update_elements(dt)
  --single thread
  if THREADS == 1 or not ENEMY_LOGIC then
    for i, element in ipairs(ELEMENTS) do
      element:update(dt)
    end
  else
    --multi thread
    for i, element in ipairs(ELEMENTS) do
      if element.id ~= "enemy" then
        element:update(dt)
      end
    end

    --parallelize the update logic for enemies
    local threads = {}
    for i = 1, THREADS - 1 do
      table.insert(threads, love.thread.newThread(require "thread_code.update_enemy_logic"))
    end
    for i, thread in ipairs(threads) do
      thread:start(SIMULATION_SIZE, dt, WIN_S.x, WIN_S.y)
    end
    --send to channel
    local cont_enemies = 0
    local channel_element = love.thread.getChannel("element")
    for i, element in ipairs(ELEMENTS) do
      if element.id == "enemy" then
        cont_enemies = cont_enemies + 1
        local soft_element = util.create_soft(element, i)
        channel_element:push(soft_element)
      end
    end

    for i = 1, THREADS - 1 do
      channel_element:push("finished")
    end

    local ret_channel = love.thread.getChannel("ret_data")
    for i = 1, cont_enemies do
      local soft_enemy = ret_channel:demand()
      util.update_element(soft_enemy, ELEMENTS[soft_enemy.index])
    end

    for i, thread in ipairs(threads) do
      thread:wait()
    end
  end
end
