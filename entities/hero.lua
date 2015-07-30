require "entities.entity"
local anim8 = require 'anim8'


Hero = {} 
Hero.__index = Hero 

function Hero.init(name, image, x, y, w, h, world)
  local self = setmetatable(Hero,{__index = Entity.init(name, image, x, y, w, h, world)})
  --local priv = {self.x, self.y, self.image, self.ms}
  --local self = make_proxy(Entity, priv, nil, nil, true)

  --init animation--
  self.animations = {}
  self.images = {}
  self.initAnimation(self)
  self.animation = nil
  self.image = nil

  return self
end

function Hero:initAnimation(width, height)
  local width = 16 or width -- default
  local height = 16 or height 

  local idle_image = love.graphics.newImage('data/gfx/hero/MainCharIdleAnimation1.png')
  local idle_g = anim8.newGrid(width, height, idle_image:getWidth(), idle_image:getHeight())
  local idle_animation = anim8.newAnimation(idle_g('1-4',1), 0.5)

  local walk_image = love.graphics.newImage('data/gfx/hero/WalkingAnimation.png')
  local walk_g = anim8.newGrid(width, height, walk_image:getWidth(), walk_image:getHeight())
  local walk_right_animation = anim8.newAnimation(walk_g('1-4',1), 0.1)
  local walk_left_animation = walk_right_animation:clone()
  walk_left_animation:flipH()

  self.animations = {idle_animation = idle_animation, walk_right_animation = walk_right_animation,
    walk_left_animation = walk_left_animation }
  self.images = {idle_image = idle_image, walk_image = walk_image}
end

function Hero:changeVelocityByKeys(dt)
  if love.keyboard.isDown("up") and self.onGround == true then
    print("ama jump")
    self.vel.y = self.vel.y - self.jumpPower * dt
    self.isJump = true 
    self.onGround = false
  end



  --if love.keyboard.isDown("down") then
  --  self.vel.y = self.vel.y + self.ms * dt 
  --end
   
  if love.keyboard.isDown("right") then
    self.vel.x = self.vel.x + self.ms * dt 
  end
   
  if love.keyboard.isDown("left") then
    self.vel.x = self.vel.x - self.ms * dt 
  end
end

function Hero:playEffect(dt)
  --if self.onGround == false then
    self.animation = self.animations.idle_animation
    self.image = self.images.idle_image
  --end

  if self.vel.x > 0 then
    self.animation = self.animations.walk_right_animation
    self.image = self.images.walk_image
  end

  if self.vel.x < 0 then
    self.animation = self.animations.walk_left_animation
    self.image = self.images.walk_image
  end

  self.animation:update(dt)
end

function Hero:update(dt)

  self:changeVelocityByKeys(dt)
	self:gravityEffect(dt)
  self:collideEffect(dt)

  self:playEffect(dt)

  self.vel:clear()

	--Entity.update(self)
end

function Hero:draw()
  self.animation:draw(self.image, self.x, self.y)
end


return Hero