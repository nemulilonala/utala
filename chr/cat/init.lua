--handle extending from the main class
chrcat = {}
chrcat.__index = chrcat 
function chrcat:new(playerid,xpos,ypos)
  local instance = playerclass:new(playerid,xpos,ypos)
  setmetatable(instance, self)
  instance:init()
  return instance
end
setmetatable(chrcat, {__index = playerclass})



function chrcat:init()
  self.statefuncs = {
    idle = function () 
      self:genswitchstate({"atk5a","walkf","walkb"},30,"idle")
      self.xspd = 0
      self.yspd = 0
      self:facex(self.otherplayer.x)
    end,
    walkf = function () 
      self:genswitchstate({"atk5a","idle","walkb"},30,"walkf")
      self.xspd = 2*self.facing 
      self.yspd = 0
      self:facex(self.otherplayer.x)
    end,
    walkb = function () 
      self:genswitchstate({"atk5a","idle","walkf"},30,"walkb")
      self.xspd = 2*-self.facing 
      self.yspd = 0
      self:facex(self.otherplayer.x)
    end,
    atk5a = function ()
      self:genswitchstate({},35,"idle")
      if self.curframe == 1 then self.yspd = 10 self.xspd = 0
      elseif self.curframe == 11 then self.yspd = 0 self.xspd = 10*self.facing
      elseif self.curframe == 21 then self.yspd = -10 self.xspd = 0
      end
    end
}
end

function chrcat:update()
  self.statefuncs[self.state]()
end


function chrcat:switchstate(_test)
  if      _test == "idle"   then if   self.hdir == 0        then return true end
  elseif  _test == "walkf"  then if   self.hdir == 1        then return true end
  elseif  _test == "walkb"  then if   self.hdir == -1       then return true end 
  elseif  _test == "atk5a"  then if   self.but.jatk == true         then return true end 
end
end

