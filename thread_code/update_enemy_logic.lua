return [[

local function update_movement(data, dt, win_x, win_y)
  data.pos_x = data.pos_x + data.dir_x * data.speed * dt
  data.pos_y = data.pos_y + data.dir_y * data.speed * dt

  if data.pos_x + data.size_x > win_x then
    data.pos_x = win_x - data.size_x
    data.dir_x = -data.dir_x
  elseif data.pos_x < 0 then
    data.pos_x = 0
    data.dir_x = -data.dir_x
  end
  if data.pos_y + data.size_y > win_y then
    data.pos_y = win_y - data.size_y
    data.dir_y = -data.dir_y
  elseif data.pos_y < 0 then
    data.pos_y = 0
    data.dir_y = -data.dir_y
  end
end

local function update_logic(simulation_size)
  for i = 0, simulation_size do
    --complex things in games enemies would do
  end
end

local simulation_size, dt, win_x, win_y = ...
local channel = love.thread.getChannel("element")
local ret_channel = love.thread.getChannel("ret_data")
while (true) do
  local data = channel:demand()
  if data == "finished" then
    break
  else
    if not data.active then
      data.growing = data.growing + dt
      if data.growing >= data.growth_time then
        data.growing = data.growth_time
        data.active = true
      end
    else
      update_movement(data, dt, win_x, win_y)
      update_logic(simulation_size)
    end
    --return data to update enemy
    ret_channel:push(data)
  end
end
]]
