local animations = {}
local images = {}

function loadGfx()
	local ShootgunGuy = love.graphics.newImage('data/gfx/hero/MainCharIdleAnimation1.png')
	local idle_g = anim8.newGrid(width, height, idle_image:getWidth(), idle_image:getHeight())
	local idle_animation = anim8.newAnimation(idle_g('1-4',1), 0.5)
end