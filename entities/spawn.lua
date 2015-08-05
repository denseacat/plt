require "cls"
require "deepcopy.deepcopy"
require "entities.enemy"

local enemies_data = require "data.cfg.enemies_cfg"


EnemyManager = {} 
EnemyManager.__index = EnemyManager 

function EnemyManager.init()
  local self = setmetatable({}, EnemyManager)
  --local priv = {}
  --local self = make_proxy(EnemyManager, priv, nil, nil, true)

  self.enemy_base = {}
  self.enemy_list = {}
  self.last_id = 0
  return self
end

function EnemyManager:create(enemy)
	self.enemy[last_id] = enemy
	self.last_id = last_id + 1
end

function EnemyManager:loadRawEnemy(name)
	if enemies_data[name] == nil then
	    print('cant find ' .. name)
		return false
	end
	local raw_enemy = enemies_data[name]
	local w = raw_enemy.width
	local h = raw_enemy.height
	local animation_pack = {
		animations = raw_enemy.animations,
		images = raw_enemy.images
	}

	local enemy = Enemy.init(name, nil, nil, w, h, nil, animation_pack)
	self.enemy_base[name] = enemy
end

function EnemyManager:spawn(name, x, y, world)
	local enemy_to_spawn = self.enemy_base[name]
	local new_enemy = nil

	if enemy_to_spawn then
	    --new_enemy = enemy_to_spawn
		print(name .. ' found')
	else
	    print("trying to load " .. name)
	    self:loadRawEnemy(name)

	    enemy_to_spawn = self.enemy_base[name]
	    if enemy_to_spawn then
	        print(name .. ' is load')
	       -- new_enemy = enemy_to_spawn
	   	else
	   		print(name .. ' not exist')
	   		print(name .. ' dont load')
	   		return false
	   	end
	end
	
	params = {value_ignore = {animations = true, images = true}}

	new_enemy = table.deepcopy(enemy_to_spawn, params)
	new_enemy.images = enemy_to_spawn.images
	new_enemy:cloneAnimaion(enemy_to_spawn.animations)
	new_enemy.x = x
	new_enemy.y = y
	new_enemy:addToWorld(world)
	table.insert(self.enemy_list, new_enemy)
	return new_enemy
end

function EnemyManager:updateEnemies(dt)
	for _,enemy in pairs(self.enemy_list) do
		enemy:update(dt)
	end
end

function EnemyManager:drawAll()
	for _,enemy in pairs(self.enemy_list) do
		--print(enemy.x)
		enemy:draw()
	end
end

return EnemyManager