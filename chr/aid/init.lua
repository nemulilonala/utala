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
    
  self.statefuncs = {
    idle = function () 
      self:genswitchstate({"atk5a","crouch","walkf","walkb"},30,"idle")
      self.xspd = 0
      self.yspd = 0
      self:facex(self.otherplayer.x)
      self.sprite = self.sprites.idle
      self.drawframe = 1
    end,
    walkf = function () 
      self:genswitchstate({"atk5a","crouch","idle","walkb"},30,"walkf")
      self.xspd = 2*self.facing 
      self.yspd = 0
      self:facex(self.otherplayer.x)
      self.sprite = self.sprites.idle
      self.drawframe = 1
    end,
    walkb = function () 
      self:genswitchstate({"atk5a","crouch","idle","walkf"},30,"walkb")
      self.xspd = 2*-self.facing 
      self.yspd = 0
      self:facex(self.otherplayer.x)
      self.sprite = self.sprites.idle
      self.drawframe = 1
    end,
    atk5a = function ()
      self:genswitchstate({},35,"idle")
      if self.curframe == 1 then self.yspd = 10 self.xspd = 0
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
      self:genswitchstate({"atk5a","idle","walkf","walkb"},30,"crouch")
      self.xspd = 0
      self.yspd = 0
      self:facex(self.otherplayer.x)
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
end
end

