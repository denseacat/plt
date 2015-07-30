require "cls"

Vector = {} 
Vector.__index = Vector


function Vector.init(x, y)
  local self = setmetatable({}, Vector)
  local priv = {self.x, self.y}
  local self = make_proxy(Vector, priv, nil, nil, true)

  self.x = x
  self.y = y

  return self
end

function Vector:clear()
	self.x = 0
	self.y = 0
end

return Vector