require "cls"
require "utils"

local gravityAccel  = 500

Entity = {} 
Entity.__index = Entity 

function Entity.init(name, image, x, y, w, h, world)
  local self = setmetatable({}, Entity)
  local priv = {self.x, self.y, self.image, self.ms}
  local self = make_proxy(Entity, priv, nil, nil, true)

  self.name = name
  self.image = image
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.ms = 250 -- default
  self.jumpPower = 500
  self.world = world

  self.vel = Vector.init(0,0)
  self.onGround = false
  self.isJump = false

  return self
end

function Entity:get_image()
	return self.image
end

function Entity:get_x()
	return self.x
end

function Entity:get_y()
	return self.y
end

function Entity:gravityEffect(dt)
  self.vel.y = self.vel.y + gravityAccel * dt
end



function Entity:collideEffect(dt)
  local old_y = self.y

  if self.vel.x ~= 0 or self.vel.y ~= 0 then
    self.x, self.y, cols, cols_len = self.world:move(self, self.x + self.vel.x, self.y + self.vel.y)
  end

  for i,col in ipairs(cols) do
    if col.item.x > col.other.x then
      self.onGround = true
    else
        self.onGround = false
    end
  end

end

function Entity:destroy()
  self.world:remove(self)
end


function Entity:update()
	self.x = self.x + self.vel.x
	self.y = self.y + self.vel.y

	self.vel:clear()
end


function Entity:draw()
  love.graphics.draw(self.image, self.x, self.y)
end



return Entity