-- define
playerclass = {} 
playerclass.__index = playerclass 

-- constructor
function playerclass:new(playerid,xpos,ypos)
  local instance = setmetatable({}, playerclass)
  instance.id = playerid
  if playerid == 2 then instance.facing = -1 else instance.facing = 1 end 
  instance.otherplayer = self
  instance.x = xpos
  instance.y = ypos
  -- both collision and sprites should probably be changed to sssomething else instead of being raw data like this
  instance.collision = {w = 26, h = 90}
  instance.sprites = {
			idle = {
				{
					img = love.graphics.newImage('nine_lives_idle.png'),
					x = 18,
					y = 106
				}
			}
		}
  instance.sprite = instance.sprites.idle
  instance.frame = instance.sprite[1]
--[[  instance.but.left = false
  instance.but.right = false
  instance.but.atk = false]]--
  instance.but = {left = false, right = false, atk = false, jatk = false}
  instance.butprev = {left = false, right = false, atk = false, jatk = false}
  instance.hdir = 0
  instance.state = "idle"
  instance.curframe = 0
  instance.xspd = 0
  instance.yspd = 0
  return instance
end

function playerclass:getcontrols()
  self.butprev = self.but
  --get inputs, depending on player
  if self.id == 1 then
    self.but = {atk = love.keyboard.isDown( "s" ),
                left = love.keyboard.isDown( "a" ),
                right = love.keyboard.isDown( "d" )}
  elseif self.id == 2 then
    self.but = {atk = love.keyboard.isDown( "down" ),
                left = love.keyboard.isDown( "left" ),
                right = love.keyboard.isDown( "right" )}
  end
  
  --check if just pressed
  if self.but.atk and not self.butprev.atk then
    self.but.jatk=true
  else self.but.jatk=false end

  --socd cleaner
  if self.but.left and self.but.right then
    self.but.left = false
    self.but.right = false
  end
  --set hdir
  if self.but.left == true then
    self.hdir = -1
  elseif self.but.right == true then
    self.hdir = 1
  else
    self.hdir = 0
  end
  self.hdir = self.hdir * self.facing
  
end

function playerclass:begin()
  self:getcontrols()
end

function playerclass:genswitchstate(_arr,_finalframe,_finalframeswitchto)
  _newstate = ""
  for i, obj in ipairs(_arr) do
    if self:switchstate(obj) then _newstate = obj break end
  end
  if _newstate == "" then
    if self.curframe >=_finalframe then
      self:changestate(_finalframeswitchto) end
  else
    self:changestate(_newstate)
  end
end

function playerclass:changestate(_state)
  self.state = _state
  self.curframe = 0
end

function playerclass:move(_xspd, _yspd)
  self.x=self.x+self.xspd
  self.y=self.y-self.yspd
  if self.y > floorpos then self.y=floorpos end
  if self.x < self.collision.w/2 then self.x=self.collision.w/2 elseif self.x > windowbase.w-(self.collision.w/2) then self.x = windowbase.w-(self.collision.w/2) end
end

function playerclass:facex(_otherx)
  if self.x < _otherx then self.facing = 1
  elseif self.x > _otherx then self.facing = -1 end
end





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
  love.graphics.setColor(1,1,1)
  for i, obj in ipairs(self.players) do
    love.graphics.draw( obj.frame.img,                  --get the current frame's actual sprite image
                        obj.x - obj.facing*obj.frame.x, --get the current x position and offset it (direction depends on whether we're flipped or not)
                        obj.y - obj.frame.y,            --get the current y position and offset it
                        0,obj.facing,1)                 --flip the image if we're flipped
    love.graphics.points( obj.x, obj.y )                --debug, shows the exact coordinate position as a little dot
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
--[[
//disable the collision we collided with if we collided
if currentcollision {variable_instance_set(other.currentcollision,"ignore",true)}
move(xspd,yspd)
collideplayers()
//increment frame
curframe++
]]--
  end
end
  