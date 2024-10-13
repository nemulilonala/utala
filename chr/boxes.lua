-- define
boxclass = {} 
boxclass.__index = boxclass 

-- constructor
function boxclass:new(_xpos,_ypos,_width,_height)
  local inst = setmetatable({}, boxclass)
  inst.x = _xpos
  inst.y = _ypos
  inst.w = _width
  inst.h = _height
  return inst
end

-- hurtbox subclass
hurtboxclass = {}
hurtboxclass.__index = hurtboxclass 
function hurtboxclass:new(_xpos,_ypos,_width,_height)
  local instance = boxclass:new(_xpos,_ypos,_width,_height)
  setmetatable(instance, self)
  --set vars here
  
  return instance
end
setmetatable(hurtboxclass, {__index = boxclass})

-- hitbox subclass
hitboxclass = {}
hitboxclass.__index = hitboxclass 
function hitboxclass:new(_xpos,_ypos,_width,_height)
  local instance = boxclass:new(_xpos,_ypos,_width,_height)
  setmetatable(instance, self)
  --set vars here  
  
  return instance
end
setmetatable(hitboxclass, {__index = boxclass})

