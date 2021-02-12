size  = 20
steps = 2000
mix   = 100
angle = 0

won       = false
won_timer = 0

map  = {}

lerp = (a, b, t) -> a + (b - a) * t

goal =
  x: 0
  y: 0

player =
  x: 0
  y: 0
  dx: 0
  dy: 0
  speed: 10

player.update = (dt) =>
  @dx = lerp @dx, @x * size, dt * @speed
  @dy = lerp @dy, @y * size, dt * @speed

math.randomseed os.time!

width  = love.graphics.getWidth!  / size
height = love.graphics.getHeight! / size

make_map = (map) ->
  for x = 0, width
    row = {}
    for y = 0, height
      row[y] = 0
    map[x] = row

  wx = math.random width / 10, width - width / 10
  wy = math.random height / 10, height - height / 10

  wr = math.random 0, 3

  for i = 0, steps
    if mix > math.random 0, 100
       wr = math.random 0, 3

    switch wr
      when 0
        wx += 1
      when 1
        wy += 1
      when 2
        wx -= 1
      when 3
        wy -= 1

    wx %= width
    wy %= height

    map[wx][wy] = 1

    if i == steps / 5
      player.x = wx
      player.y = wy

    if i == steps
        goal.x = wx
        goal.y = wy

with love
  .load = ->
    print "nice"

    make_map map

  .draw = ->
    for x = 0, #map
      for y = 0, #map[0]
        if map[x][y] == 1
          .graphics.setColor 0.35, 1, 0.5
          .graphics.rectangle "fill", x * size, y * size, size, size

    .graphics.setColor 0.35, 0.5, 1 
    .graphics.rectangle "fill", player.dx, player.dy, size, size
    
    .graphics.setColor 1, 1, 0.5
    .graphics.rectangle "fill", goal.x * size, goal.y * size, size, size

    if won
      .graphics.setColor 1, 1, 0.5, won_timer
      .graphics.rectangle "fill", 0, 0, .graphics.getWidth!, .graphics.getHeight!

  .update = (dt) ->
    player\update dt
    angle += dt * 2

    if won_timer > 0
      won_timer -= dt

      make_map map

      if won_timer <= 0
        won = false

  .keypressed = (key) ->
    oldx = player.x
    oldy = player.y
    switch key
      when "left"
        player.x -= 1
        player.x %= width
      when "right"
        player.x += 1
        player.x %= width
      when "up"
        player.y -= 1
        player.y %= height
      when "down"
        player.y += 1
        player.y %= height

    if map[player.x] and map[player.x][player.y] == 0
      player.x = oldx
      player.y = oldy

    if player.x == goal.x and player.y == goal.y
      won = true
      won_timer = 1.5