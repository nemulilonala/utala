playermanager = {}
playermanager.__index = playermanager


function playermanager:new()
  local manager = setmetatable({}, playermanager)
  manager.players = {}
  return manager
end

function playermanager:addplayer(objplr)
  table.insert(self.players,objplr)
end

function playermanager:spawnplayers(p1char, p2char)
  player1 = p1char:new(1,	(stagewidth/2) - (startingdist/2),	floorpos)
  player2 = p2char:new(2,	(stagewidth/2) + (startingdist/2),	floorpos)
  pman:addplayer(player1)
  pman:addplayer(player2)
  player1.otherplayer = player2
  player2.otherplayer = player1
end

function playermanager:removeplayerbyid(id)
  for i, obj in ipairs(self.players) do
    if obj.name == name then
      table.remove(self.objects,i)
      return true
    end
  end
  return false
end

function playermanager:drawstep()
  for i, obj in ipairs(self.players) do
    love.graphics.setColor(1,1,1)
    obj.frame = obj.sprite[obj.drawframe]
    love.graphics.draw( obj.frame.img,                  --get the current frame's actual sprite image
                        obj.x - obj.facing*obj.frame.x, --get the current x position and offset it (direction depends on whether we're flipped or not)
                        obj.y - obj.frame.y,            --get the current y position and offset it
                        0,obj.facing,1)                 --flip the image if we're flipped
    if debug then
    love.graphics.points( obj.x, obj.y )                --debug, shows the exact coordinate position as a little dot
    love.graphics.setColor(1,1,0,0.5)
    love.graphics.rectangle("fill",obj.x-(obj.collision.w/2),obj.y-obj.collision.h,obj.collision.w,obj.collision.h)
    end
  end
end


function playermanager:beginstep()
  for i, obj in ipairs(self.players) do
    obj:begin()
  end
end
function playermanager:endstep()
  for i, obj in ipairs(self.players) do
    obj:update()
    obj:move(obj.xspd,obj.yspd)
    obj.curframe=obj.curframe+1
  end
  
  
  --collide players (i probably overcomplicated this but oh well it works now and thats what matters)
  _p1 = self.players[1]
  _p2 = self.players[2]
  _xdis = math.abs(_p1.x-_p2.x)
  _ydis = math.abs(_p1.y-_p2.y)
  _combw = (_p1.collision.w/2)+(_p2.collision.w/2)
  _combh = (_p1.collision.h/2)+(_p2.collision.h/2)
  if (_xdis < _combw) and (_ydis < _combh) then
      _hdepth = _combw-_xdis
      _pushdir = 0 --  dpends on p1. push to the left (-1) if p1 is on left, push on right (1) if p1 is on right
      if _p1.x < _p2.x then
        --print("p1 collided with p2 on the left")
        _pushdir = -1
      elseif _p1.x > _p2.x then
        --print("p2 collided with p1 on the left")
        _pushdir = 1
      else
        --print("players share the same position") -- so push based on facing dir
        _pushdir = _p1.facing
      end
    _avgx = (_p1.x+_p2.x)/2
    if _pushdir == -1 then
      if _p1.x <
      (_p1.collision.w / 2) --furthest left p1 can be
      + (_hdepth/2) -- add half the depth. so if p1 is less than half the depth away from the screen edge. i.e. would this push push p1 oob
      then
      --handle collision with screen edge
      --print ("p1 left")
      _p1.x = _p1.collision.w/2
      _p2.x = _p1.collision.w + _p2.collision.w/2
      elseif _p2.x >  stagewidth - (_p2.collision.w / 2) - (_hdepth/2) then
      --p2 right wall
      --print ("p2 right")
      _p1.x = stagewidth - _p2.collision.w - _p1.collision.w/2
      _p2.x = stagewidth - _p2.collision.w/2
      else
      --midscreen, comfiest spot to code up
      _p1.x=_avgx+((_combw/2)*_pushdir)
      _p2.x=_avgx+((_combw/2)*-_pushdir)
      end
    elseif _pushdir == 1 then
      if _p2.x < (_p2.collision.w / 2) + (_hdepth/2) then
      --same thing but for p2
      --print ("p2 left")
      _p2.x = _p2.collision.w/2
      _p1.x = _p2.collision.w + _p1.collision.w/2
      elseif _p1.x >  stagewidth - (_p1.collision.w / 2) - (_hdepth/2) then
      --p1 right wall
      --print ("p1 right")
      _p2.x = stagewidth - _p1.collision.w - _p2.collision.w/2
      _p1.x = stagewidth - _p1.collision.w/2
      else
      --midscreen, comfiest spot to code up
      _p1.x=_avgx+((_combw/2)*_pushdir)
      _p2.x=_avgx+((_combw/2)*-_pushdir)
      end
    end
end
  end