require "cls"
require "cfg"
require "entities.spawn"

loader = require("tiledloader.Loader")
loader.path = "data/maps/"

local bump = require 'bump'


Tile = {} 
Tile.__index = Tile

function Tile.init(name, image, x, y, block)
  local self = setmetatable({}, Tile)
  local priv = {self.x, self.y, self.w, self.h, self.image, self.block}
  local self = make_proxy(Tile, priv, nil, nil, true)

  self.name = name
  self.image = image
  self.x = x
  self.y = y
  self.w = image:getWidth()
  self.h = image:getHeight()
  self.block = block

  return self
end


Level = {} 
Level.__index = Level

function Level.init(enemy_manager)
  local self = setmetatable({}, Level)

  self.enemy_manager = enemy_manager
  self.tiles = {}
  self.world = bump.newWorld()
  self.hero = nil

  return self
end

function Level:load(filepath)
  map = loader.load(filepath)
  --map:autoDrawRange(100, 100, 100, 0)

  for x, y, tile in map("block"):iterate() do
    self:addBlock(x*tile.width, y*tile.height, tile.width, tile.height)
  end

  for _, layer in pairs(map.layers) do
    if layer.class == "ObjectLayer" then
      for _, obj in pairs(layer.objects) do
          if obj.type == "enemy" then 
            enemy = self.enemy_manager:spawn(obj.name, obj.x, obj.y, self.world)
          end
      end
    end
  end


  self.map = map
end


function Level:addBlock(x, y, w, h)
	local block = {x=x,y=y,w=w,h=h}
	--blocks[#blocks+1] = block
	self.world:add(block, x,y,w,h)

end

function Level:draw(camera)
  local x = math.ceil(camera.x / camera.scale)
  local y = math.ceil(camera.y / camera.scale)

  self.map:setDrawRange(x,y, camera.w * camera.scale, camera.h * camera.scale)
  --map:autoDrawRange(x, y)
  self.map:draw()
  --self.map:forceRedraw ()
end


return Level