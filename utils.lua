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

function isColliding(a,b)
	if ((b.x >= a.x + a.w) or
		(b.x + b.w <= a.x) or
		(b.y >= a.y + a.h) or
		(b.y + b.h <= a.y)) then
			return false 
	else return true
		end
end

function recursive_deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

return Vector