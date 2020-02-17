return [[
local simulation_size = ...
local channel = love.thread.getChannel("element")
while (true) do
  local data = channel:demand()
  if data == "finished" then
    break
  elseif data == "enemy" then
    for i = 0, simulation_size do
      --complex things in games enemies would do
    end
  end
end
]]
