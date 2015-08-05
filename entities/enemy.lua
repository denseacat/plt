require "entities.entity"

Enemy = {} 
Enemy.__index = Enemy 

function Enemy.init(name, x, y, w, h, world, animation_pack)
  local self = setmetatable(Enemy,{__index = Entity.init(name, nil, x, y, w, h, world)})
  --local priv = {self.x, self.y, self.image, self.ms}
  --local self = make_proxy(Entity, priv, nil, nil, true)

  --init animation--
  self.animations = animation_pack.animations
  self.images = animation_pack.images
  self.animation = nil
  self.reverse_animations = nil
  self.image = nil
  self.to_right = true
  --self.initAnimation(self)

  return self
end

function Enemy:cloneAnimaion(animations)
	self.animations = {}
	self.reverse_animations = {}
	for key, value in pairs(animations) do
		self.animations[key] = value:clone()
		local reverse_animation = value:clone()
		reverse_animation:flipH()
		self.reverse_animations[key] = reverse_animation
	end

end

function Enemy:playEffect(dt)
  --if self.onGround == false then
    local current_animation = "idle"
    local current_image = "idle"
  --end

  if self.vel.x ~= 0 then
    current_animation = "walk"
    current_image = "walk"

    self.to_right = false
    if self.vel.x > 0 then
      self.to_right = true
    end
  end

  self.image = self.images[current_image]
  if self.to_right == true then
    self.animation = self.animations[current_animation]
  else
    self.animation = self.reverse_animations[current_animation]
  end


  self.animation:update(dt)
end

function Enemy:update(dt)
	self:gravityEffect(dt)
	self:collideEffect(dt)

	self:playEffect(dt)

	self.vel.x = 0
end


function Enemy:draw()
  self.animation:draw(self.image, self.x, self.y)
end


return Enemy