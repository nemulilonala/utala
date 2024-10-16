--handle extending from the main class
chraid = {}
chraid.__index = chraid 
function chraid:new(playerid,xpos,ypos)
  local instance = playerclass:new(playerid,xpos,ypos)
  setmetatable(instance, self)
  instance:init()
  return instance
end
setmetatable(chraid, {__index = playerclass})



function chraid:init()
  self.collision = {w = 18, h = 42}
  
  sdir = 'chr/aid/spr/'
  self.sprites = {
    idle = {
      {
        img = love.graphics.newImage(sdir..'idle.png'),
        x = 64,
        y = 128
      }
    },
    crouch = {
      {
        img = love.graphics.newImage(sdir..'crouch.png'),
        x = 64,
        y = 128
      }
    }
  }
  self.sprite = self.sprites.idle
  self.drawframe = 1

  self.switchstates = {
    idle = function()       self:genswitchstate({"atk5a","jumpsquat","crouch","walkf","walkb"},30,"idle") end,
    walkf = function ()     self:genswitchstate({"atk5a","jumpsquat","crouch","idle","walkb"},30,"walkf") end,
    walkb = function ()     self:genswitchstate({"atk5a","jumpsquat","crouch","idle","walkf"},30,"walkb") end,
    atk5a = function ()     self:genswitchstate({},35,"idle") end,
    crouch = function()     self:genswitchstate({"atk5a","jumpsquat","idle","walkf","walkb"},30,"crouch") end,
    jumpsquat = function () self:genswitchstate({},30,"idle") end,
    airborne = function()   self:genswitchstate({"land"},30,"airborne") end,
    land = function ()      self:genswitchstate({},5,"idle") end
  }

  self.statefuncs = {
    idle = function () 
        self.xspd = 0
        self.yspd = 0
        self:facex(self.otherplayer.x)
        if self.curframe == 0 then
          self.sprite = self.sprites.idle
          self.drawframe = 1
          self:createhurtbox(0,0,24,55)
        end
      end,
    walkf = function () 
      self.xspd = 4*self.facing 
      self.yspd = 0
      self:facex(self.otherplayer.x)
      self.sprite = self.sprites.idle
      self.drawframe = 1
      end,
    walkb = function () 
      self.xspd = 3*-self.facing 
      self.yspd = 0
      self:facex(self.otherplayer.x)
      self.sprite = self.sprites.idle
      self.drawframe = 1
      end,
    atk5a = function ()
      if self.curframe == 0 then self.yspd = 10 self.xspd = 0
        self.sprite = self.sprites.idle
        self.drawframe = 1
      elseif self.curframe == 11 then self.yspd = 0 self.xspd = 10*self.facing
        self.sprite = self.sprites.crouch
        self.drawframe = 1
      elseif self.curframe == 21 then self.yspd = -10 self.xspd = 0
        self.sprite = self.sprites.idle
        self.drawframe = 1
        end
      end,
    crouch = function()
      self.xspd = 0
      self.yspd = 0
      self:facex(self.otherplayer.x)
      self.sprite = self.sprites.crouch
      self.drawframe = 1
      end,
    jumpsquat = function()
      
      if self.curframe == 0 then self.yspd = 0 self.xspd = 0
        self.sprite = self.sprites.crouch
        self.drawframe = 1
      elseif self.curframe >= 4 then
        self.yspd = 12 self.xspd = 4*self.facing*self.hdir
        self.sprite = self.sprites.idle
        self.drawframe = 1
        self:changestate("airborne")
      end
      end,
    airborne = function()
      self.yspd = math.max(self.yspd-0.5,-15)
      self.sprite = self.sprites.idle
      self.drawframe = 1
      end,
    land = function()
      
      self.xspd = 0
      self.yspd = 0
      self.sprite = self.sprites.crouch
      self.drawframe = 1
      end
    }
end




function chraid:switchstate(_test)
  if      _test == "idle"   then if   self.ndir == 5        then return true end
  elseif  _test == "walkf"  then if   self.ndir == 6        then return true end
  elseif  _test == "walkb"  then if   self.ndir == 4       then return true end 
  elseif  _test == "atk5a"  then if   self.but.jatka == true then return true end 
  elseif  _test == "crouch"  then if   self.vdir == -1 == true then return true end 
  elseif  _test == "jumpsquat"  then if   self.vdir == 1 == true then return true end 
  elseif _test == "land" then if self.y >= floorpos then return true end
end
end

