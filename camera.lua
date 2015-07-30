require "cls"
require "cfg"

Camera = {} 
Camera.__index = Camera 

function Camera.init(x, y, w, h)
	local self = setmetatable({}, Camera)
	local priv = {self.x, self.y, self.w, self.h}
	local self = make_proxy(Camera, priv, nil, nil, true)

	self.x = x
	self.y = y
	self.w = w
	self.h = h

	self._old_x = 0
	self._old_y = 0

	--self.max_w = max_w
	--self.max_h = max_h
	self.scale = cfg.scale_factor

	return self
end


function Camera:bound(hero)
	-- body
end

function Camera:update(bx, by)
	self.x = bx * self.scale - self.w / 2
	self.y = by * self.scale - self.h / 1.1
	
	if self.x < 0 then
		self.x = 0
	end
	if self.y < 0 then
		self.y = 0
	end
end

function Camera:set()
	love.graphics.push()
	love.graphics.translate(-self.x, -self.y)
	love.graphics.scale(self.scale)
end

function Camera:unset()
	love.graphics.pop()
end

return Camera