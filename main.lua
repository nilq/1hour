local size = 20
local steps = 2000
local mix = 100
local angle = 0
local won = false
local won_timer = 0
local map = { }
local lerp
lerp = function(a, b, t)
  return a + (b - a) * t
end
local goal = {
  x = 0,
  y = 0
}
local player = {
  x = 0,
  y = 0,
  dx = 0,
  dy = 0,
  speed = 10
}
player.update = function(self, dt)
  self.dx = lerp(self.dx, self.x * size, dt * self.speed)
  self.dy = lerp(self.dy, self.y * size, dt * self.speed)
end
math.randomseed(os.time())
local width = love.graphics.getWidth() / size
local height = love.graphics.getHeight() / size
local make_map
make_map = function(map)
  for x = 0, width do
    local row = { }
    for y = 0, height do
      row[y] = 0
    end
    map[x] = row
  end
  local wx = math.random(width / 10, width - width / 10)
  local wy = math.random(height / 10, height - height / 10)
  local wr = math.random(0, 3)
  for i = 0, steps do
    if mix > math.random(0, 100) then
      wr = math.random(0, 3)
    end
    local _exp_0 = wr
    if 0 == _exp_0 then
      wx = wx + 1
    elseif 1 == _exp_0 then
      wy = wy + 1
    elseif 2 == _exp_0 then
      wx = wx - 1
    elseif 3 == _exp_0 then
      wy = wy - 1
    end
    wx = wx % width
    wy = wy % height
    map[wx][wy] = 1
    if i == steps / 5 then
      player.x = wx
      player.y = wy
    end
    if i == steps then
      goal.x = wx
      goal.y = wy
    end
  end
end
do
  local _with_0 = love
  _with_0.load = function()
    print("nice")
    return make_map(map)
  end
  _with_0.draw = function()
    for x = 0, #map do
      for y = 0, #map[0] do
        if map[x][y] == 1 then
          _with_0.graphics.setColor(0.35, 1, 0.5)
          _with_0.graphics.rectangle("fill", x * size, y * size, size, size)
        end
      end
    end
    _with_0.graphics.setColor(0.35, 0.5, 1)
    _with_0.graphics.rectangle("fill", player.dx, player.dy, size, size)
    _with_0.graphics.setColor(1, 1, 0.5)
    _with_0.graphics.rectangle("fill", goal.x * size, goal.y * size, size, size)
    if won then
      _with_0.graphics.setColor(1, 1, 0.5, won_timer)
      return _with_0.graphics.rectangle("fill", 0, 0, _with_0.graphics.getWidth(), _with_0.graphics.getHeight())
    end
  end
  _with_0.update = function(dt)
    player:update(dt)
    angle = angle + (dt * 2)
    if won_timer > 0 then
      won_timer = won_timer - dt
      make_map(map)
      if won_timer <= 0 then
        won = false
      end
    end
  end
  _with_0.keypressed = function(key)
    local oldx = player.x
    local oldy = player.y
    local _exp_0 = key
    if "left" == _exp_0 then
      player.x = player.x - 1
      player.x = player.x % width
    elseif "right" == _exp_0 then
      player.x = player.x + 1
      player.x = player.x % width
    elseif "up" == _exp_0 then
      player.y = player.y - 1
      player.y = player.y % height
    elseif "down" == _exp_0 then
      player.y = player.y + 1
      player.y = player.y % height
    end
    if map[player.x] and map[player.x][player.y] == 0 then
      player.x = oldx
      player.y = oldy
    end
    if player.x == goal.x and player.y == goal.y then
      won = true
      won_timer = 1.5
    end
  end
  return _with_0
end
