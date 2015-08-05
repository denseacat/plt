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
  self.animation = nil
  self.reverse_animations = nil
  self.image = nil
  self.initAnimation(self)

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
  local walk_animation = anim8.newAnimation(walk_g('1-4',1), 0.1)

  self.animations = {idle = idle_animation, walk = walk_animation}
  self.images = {idle = idle_image, walk = walk_image}

  -- reverse animation --
  local reverse_idle = idle_animation:clone()
  reverse_idle:flipH()

  local reverse_walk = walk_animation:clone()
  reverse_walk:flipH()

  self.reverse_animations = {idle = reverse_idle, walk = reverse_walk}
end

function Hero:changeVelocityByKeys(dt)
  if love.keyboard.isDown("up") then
    self:jump(dt)
  end



  --if love.keyboard.isDown("down") then
  --  self.vel.y = self.vel.y + self.ms * dt 
  --end
   
  if love.keyboard.isDown("right") then
    self.vel.x = self.ms * dt 
  end
   
  if love.keyboard.isDown("left") then
    self.vel.x = -self.ms * dt 
  end
end

function Hero:playEffect(dt)
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

function Hero:update(dt)

  self:changeVelocityByKeys(dt)
	self:gravityEffect(dt)
  self:collideEffect(dt)

  self:playEffect(dt)

  self.vel.x = 0

	--Entity.update(self)
end

function Hero:draw()
  self.animation:draw(self.image, self.x, self.y)
end


return Hero