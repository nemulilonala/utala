require "chr" --handles loading of all chr lua files

--because its a FIGHTER GAME and fighter games run at 60 fps so we need something to facilitate that
--these are the variables used to do so
local tickrate = 1/60
local accumulator = 0.0


function love.load()
  debug = false
  --graphics and stage size
  love.graphics.setDefaultFilter("nearest", "nearest")
  bg = love.graphics.newImage('img/bg/mountains.png')
  windowbase = { w = 1072, h = 603}
  windowcurrent = windowbase
  windowscale = { w = 1, h = 1, x = 1}
  --players and stage
	floorpos = windowbase.h-100
	startingdist = 200
	stagewidth = windowbase.w
  pman = playermanager.new()
  pman:spawnplayers(chraid, chrcat)
  
  --init config
  local configpath = "config.cfg"
  local configstr = love.filesystem.read(configpath)
  config = {}
  for line in configstr:gmatch("[^\r\n]+") do
    local key, value = line:match("^(%S+)%s*=%s*(%S+)")
    if key and value then
        config[key] = value
    end
  end
  
  --init controls from config
  p1cont = {
    atka = config.p1atka or "y",
    atkb = config.p1atkb or "u",
    atkc = config.p1atkc or "i",
    atkd = config.p1atkd or "o",
    atke = config.p1atke or "p",
    left = config.p1left or "a",
    right = config.p1right or "d",
    up = config.p1up or "s",
    down= config.p1down or "w"
  }
  p2cont = {
    atka = config.p2atka or "h",
    atkb = config.p2atkb or "j",
    atkc = config.p2atkc or "k",
    atkd = config.p2atkd or "l",
    atke = config.p2atke or ";",
    left = config.p2left or "left",
    right = config.p2right or "right",
    up = config.p2up or "up",
    down = config.p2down or "down"
  }
end

function love.update(dt)
  --make sure tickrate is constant 60, regardless of monitor fps
  accumulator = accumulator + dt
  while accumulator > tickrate do
    accumulator = accumulator - tickrate
    --actual game logic gets called here
      pman:beginstep()
      pman:endstep()
  end
end

function love.draw()
  --center window
  if windowscale.w > windowscale.h then
    love.graphics.translate(
      ((windowbase.w*(windowscale.w-windowscale.x+1))-windowbase.w)/2
      , 0)
  elseif windowscale.w < windowscale.h then
    love.graphics.translate(0,
      ((windowbase.h*(windowscale.h-windowscale.x+1))-windowbase.h)/2
      )
  end
  --scale contents up to match window
  love.graphics.scale(windowscale.x,windowscale.x)
  --set bg
  love.graphics.setBackgroundColor( 0.3, 0.5, 0.5)
  love.graphics.setColor(1,1,1)
  love.graphics.draw(bg, -237, -89)
  if debug then
    love.graphics.setColor(1,1,1,0.1)
    love.graphics.rectangle("fill",0,0,windowbase.w,windowbase.h)
    end
  pman:drawstep()
end

function love.resize(nw,nh)
  windowcurrent = {w = nw, h = nh}
  windowscale = { w = nw/windowbase.w, h = nh/windowbase.h}
  windowscale.x = math.min(windowscale.w, windowscale.h)
end

function love.keypressed(key, scancode, isrepeat)
   if key == config.debughotkey then
      if not debug then debug = true else debug = false end
   end
end