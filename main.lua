require "entities.hero"
require "level"
require "camera"
require "entities.spawn"



function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.graphics.setNewFont(12)

  enemy_manager = EnemyManager.init()

	level = Level.init(enemy_manager)
  level:load('forest/forest1.tmx')
	
  hero = Hero.init('hero', nil, 100, 50, 16, 16, level.world)
  hero.world:add(hero, hero.x, hero.y, hero.w, hero.h)
  level.hero = hero

  cam = Camera.init(0, 0, love.graphics.getWidth(), love.graphics.getHeight())

end

function love.update(dt)
  hero:update(dt)
  enemy_manager:updateEnemies(dt)
end

function love.draw()
  cam:update(hero.x, hero.y)
  cam:set()

  --love.graphics.scale(cfg.scale_factor)
  --love.graphics.draw(hero.image, parth, hero.x, hero.y)
  level:draw(cam)
  enemy_manager:drawAll()
  hero:draw()
  cam:unset()

end
