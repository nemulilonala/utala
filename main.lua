require "chr.chrloader" --handles loading of all chr lua files

function love.load()
  --graphics
  love.graphics.setDefaultFilter("nearest", "nearest")
  windowbase = { w = 1072, h = 603}
  windowcurrent = windowbase
  windowscale = { w = 1, h = 1, x = 1}
	floorpos = rnd(windowbase.h*(5/6))
	startingdist = 200
	stagewidth = windowbase.w
  pman = playermanager.new()
  pman:spawnplayers(chrcat, chrcat)
  --rapidlyincreasingnumber = 0
end

function love.update()
  --rapidlyincreasingnumber=rapidlyincreasingnumber+1
  pman:beginstep()
  pman:endstep()
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