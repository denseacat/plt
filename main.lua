local key_states = {key_up = false, key_down = false, key_left = false, key_right = false}

require "entities.hero"
require "level"
require "camera"


function love.keypressed(key)
	if key == 'up' then
      key_states.key_up = true
    end
    
    if key == 'down' then
    	key_states.key_down = true
    end

    if key == 'left' then
    	key_states.key_left = true
    end

    if key == 'right' then
    	key_states.key_right = true
    end
end

function love.keypressed(key)

	if key == 'up' then
      key_states.key_up = false
    end
    
    if key == 'down' then
    	key_states.key_down = false
    end

    if key == 'left' then
    	key_states.key_left = false
    end

    if key == 'right' then
    	key_states.key_right = false
    end

end

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  image = love.graphics.newImage("data/gfx/newhero.png")
  parth =  love.graphics.newQuad(0, 0, 16, 16, image:getDimensions())

  love.graphics.setNewFont(12)
  --love.graphics.setColor(0,0,0)
  love.graphics.setBackgroundColor(255,255,255)


	level = Level.init(8, 8)
  level:load()
	
  hero = Hero.init('hero', image, 110, 50, 16, 16, level.world)
  

  level.world:add(hero, hero.x, hero.y, hero.w, hero.h)
  level.hero = hero

  cam = Camera.init(0, 0, love.graphics.getWidth(), love.graphics.getHeight())


end

function love.update(dt)

    hero:update(dt)

end

function love.draw()
  cam:update(hero.x, hero.y)
  cam:set()

  --love.graphics.scale(cfg.scale_factor)
  --love.graphics.draw(hero.image, parth, hero.x, hero.y)
  level:draw()
  hero:draw()

  cam:unset()

end
