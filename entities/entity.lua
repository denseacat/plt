require "cls"
require "utils"

gravityAccel  = 30

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
  self.jumpPower = 400

  self:addToWorld(world)

  self.vel = Vector.init(0,0)
  self.onGround = false
  self.isJump = false
  self.to_right = true
  return self
end

function Entity:addToWorld(world)
  if world then
    world:add(self, self.x, self.y, self.w, self.h)
  end
  self.world = world
end


function Entity:gravityEffect(dt)
  self.vel.y = ( self.vel.y + gravityAccel * dt )
end

function Entity:jump(dt)
  if self.onGround == true then
    self.vel.y = -self.jumpPower * dt
    self.onGround = false
  end
end


function Entity:collideEffect(dt)
  if self.vel.x ~= 0 or self.vel.y ~= 0 then
    self.x, self.y, cols, cols_len = self.world:move(self, self.x + self.vel.x, self.y + self.vel.y)
  end

  for i,col in ipairs(cols) do
    if col.item.x > col.other.x then
      self.onGround = true
      self.isJump = false
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