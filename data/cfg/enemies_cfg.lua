local anim8 = require 'anim8'


function enemyGFXLoader(raw_images, width, height, animations_frames, animations_timing)
	love.graphics.setDefaultFilter('nearest', 'nearest')
	local images = {}
	local animations = {}

	for name, filepath in pairs(raw_images) do
		image = love.graphics.newImage(filepath)
		grid = anim8.newGrid(width, height, image:getWidth(), image:getHeight())
		animation = anim8.newAnimation(grid(animations_frames[name],1), animations_timing[name])
		images[name] = image
		animations[name] = animation
		print(name)
	end
	return images, animations
end


RawShotgunGuy = {} 
RawShotgunGuy.__index = RawShotgunGuy 

function RawShotgunGuy.new()
	local self = setmetatable({}, RawShotgunGuy)

	self.id = 1
	self.hp = 50
	self.ms = 200
	self.width = 16
	self.height = 16
	local _gfx_path = 'data/gfx/enemies/ShotgunGuy/'
	local _raw_images = {idle = ( _gfx_path .. 'ShotgunGuyIdleAnimation.png')}
	local _animations_frames = {idle = '1-2'}
	local _animations_timing = {idle = 0.5}

	self.images, self.animations = 	enemyGFXLoader(_raw_images, self.width, self.height,
		 _animations_frames, _animations_timing)


	return self
end

RawShotgunGuy = RawShotgunGuy.new()


list = { ShotgunGuy = RawShotgunGuy}
return list