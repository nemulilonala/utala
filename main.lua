require "chr" --handles loading of all chr lua files

--because its a FIGHTER GAME and fighter games run at 60 fps so we need something to facilitate that
--these are the variables used to do so
local tickrate = 1/60
local accumulator = 0.0

function love.load()
  --graphics
  love.graphics.setDefaultFilter("nearest", "nearest")
  windowbase = { w = 1072, h = 603}
  windowcurrent = windowbase
  windowscale = { w = 1, h = 1, x = 1}
	floorpos = windowbase.h-100
	startingdist = 200
	stagewidth = windowbase.w
  pman = playermanager.new()
  pman:spawnplayers(chrcat, chrcat)
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
  love.graphics.setColor(1,0.8,0)
  love.graphics.rectangle("fill",0,0,windowbase.w,windowbase.h)
  pman:drawstep()
end

function love.resize(nw,nh)
  windowcurrent = {w = nw, h = nh}
  windowscale = { w = nw/windowbase.w, h = nh/windowbase.h}
  windowscale.x = math.min(windowscale.w, windowscale.h)
end