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
  instance.collision = {w = 26, h = 70}
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
  instance.drawframe = 1
  instance.frame = instance.sprite[instance.drawframe]
  instance.but = {left = false, right = false, atka = false, jatka = false, atkb = false, jatkb = false, atkc = false, jatkc = false, atkd = false, jatkd = false, atke = false, jatke = false}
  instance.butprev = {left = false, right = false, atka = false, jatka = false, atkb = false, jatkb = false, atkc = false, jatkc = false, atkd = false, jatkd = false, atke = false, jatke = false}
  instance.hdir = 0
  instance.vdir = 0
  instance.ndir = 5
  instance.state = "idle"
  instance.curframe = 0
  instance.xspd = 0
  instance.yspd = 0
  return instance
end

function playerclass:update()
  self.statefuncs[self.state]()
end

function playerclass:getcontrols()
  self.butprev = self.but
  --get inputs, depending on player
  if self.id == 1 then
    self.but = {atka = love.keyboard.isDown(p1cont.atka),
                atkb = love.keyboard.isDown(p1cont.atkb),
                atkc = love.keyboard.isDown(p1cont.atkc),
                atkd = love.keyboard.isDown(p1cont.atkd),
                atke = love.keyboard.isDown(p1cont.atke),
                left = love.keyboard.isDown(p1cont.left),
                right = love.keyboard.isDown(p1cont.right),
                up = love.keyboard.isDown(p1cont.up),
                down= love.keyboard.isDown(p1cont.down)}
  elseif self.id == 2 then
    self.but = {atka = love.keyboard.isDown(p2cont.atka),
                atkb = love.keyboard.isDown(p2cont.atkb),
                atkc = love.keyboard.isDown(p2cont.atkc),
                atkd = love.keyboard.isDown(p2cont.atkd),
                atke = love.keyboard.isDown(p2cont.atke),
                left = love.keyboard.isDown(p2cont.left),
                right = love.keyboard.isDown(p2cont.right),
                up = love.keyboard.isDown(p2cont.up),
                down= love.keyboard.isDown(p2cont.down)}
  end
  
  --check if just pressed
  if self.but.atka and not self.butprev.atka then
    self.but.jatka=true
  else self.but.jatka=false end
  if self.but.atkb and not self.butprev.atkb then
    self.but.jatkb=true
  else self.but.jatkb=false end
  if self.but.atkc and not self.butprev.atkc then
    self.but.jatkc=true
  else self.but.jatkc=false end
  if self.but.atkd and not self.butprev.atkd then
    self.but.jatkd=true
  else self.but.jatkd=false end
  if self.but.atke and not self.butprev.atke then
    self.but.jatke=true
  else self.but.jatke=false end

  --socd cleaner
  if self.but.left and self.but.right then
    self.but.left = false
    self.but.right = false
  end
  if self.but.up and self.but.down then
    self.but.up = true
    self.but.down = false
  end
  
  --set hdir (horizontal direction, forwards or backwards)
  if self.but.left then
    self.hdir = -1
  elseif self.but.right then
    self.hdir = 1
  else
    self.hdir = 0
  end
  self.hdir = self.hdir * self.facing  --flip it if facing left
  
  --set vdir (vertical direction, up or down)
  if self.but.up then
    self.vdir = -1
  elseif self.but.down then
    self.vdir = 1
  else
    self.vdir = 0
  end
  
  --set ndir (numpad direction)
  self.ndir = 5 + (self.vdir*3) + self.hdir
  
  
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
  --keep above ground
  if self.y > floorpos then self.y=floorpos end
  --keep within walls
  if self.x < self.collision.w/2 then self.x=self.collision.w/2 elseif self.x > stagewidth-(self.collision.w/2) then self.x = stagewidth-(self.collision.w/2) end
end

function playerclass:facex(_otherx)
  if self.x < _otherx then self.facing = 1
  elseif self.x > _otherx then self.facing = -1 end
end





