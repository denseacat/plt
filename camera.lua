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
	self.area = {x = 0, y = 0, w = w / 3, h = h * 0.1}

	return self
end


function Camera:bound(hero)
	-- body
end

function Camera:smoothScroling(bx, by)
	local centr = (self.x + self.w) / 2
	local left_border = self.x + self.area.w
	local right_border = (self.x + self.w) - self.area.w
 	--if diff_left_x < 0 then
	--	self.area.x = self.area.x + diff_left_x
	--end

	--if diff_right_x > (self.area.x + self.area.w) then
	--	self.area.x = self.area.x + diff_right_x
	--end

	if bx < left_border then
		self.area.x = bx 
	end

	if bx > right_border then
	    self.area.x = bx 
	end

end


function Camera:update(bx, by)
	local oldPosX = self.x 
	local oldPosY = self.y
	self:smoothScroling(bx, by)
	
	local left = self.x + self.area.w
	local right = (self.x + self.w) - self.area.w
	local top  = self.y + self.area.h
	local bottom = (self.y + self.h) - self.area.h

	if bx * self.scale < left then
	    self.x = self.x - (left - bx * self.scale)
	end

	if bx * self.scale > right then
	    self.x = self.x - (right - bx * self.scale)
	end

	if by * self.scale < top then
	    self.y = self.y - (top - by * self.scale)
	end

	if by * self.scale > bottom then
	    self.y = self.y - (bottom - by * self.scale)
	end


	--if self.x < 0 or (self.x > self.area.x and self.x < (self.area.x + self.area.w) ) then
	--	self.x = oldPosX
	--end
	--if self.y < 0 then
	--	self.y = oldPosY
	--end
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