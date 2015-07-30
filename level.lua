require "cls"
require "cfg"

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

function Level.init(width, height)
  local self = setmetatable({}, Level)
  local priv = {self.tiles, self.world}
  local self = make_proxy(Level, priv, nil, nil, true)

  self.width = width
  self.height = height
  
  size = width * height
  --self.tiles = love.graphics.newSpriteBatch( tileset, size )
  self.tiles = {}
  self.world = bump.newWorld()
  self.hero = nil

  return self
end

function Level:exload()
	tile_image = love.graphics.newImage("data/gfx/brick.png")
	count = 0
	local xPos, yPos = 0, 0
	for y = 1, self.height do
    	for x = 1, self.width do
     		--local xPos = x * self.tileset:getWidth()
      		--local yPos = y * self.tileset:getHeight()
      		if map[y][x] == 1 then
      			local tile = Tile.init('block', tile_image, xPos, yPos, true)
      			table.insert(self.tiles, tile)
      			self.world:add(tile, tile.x, tile.y, tile.w, tile.h)
      			count = count + 1
      		end
      		xPos = x * 32
    	end
    	xPos = 0
    	yPos = y * 32
  	end
end

function Level:load()
  map = loader.load("3/forest1.tmx")
  --map:autoDrawRange(100, 100, 100, 0)

  for x, y, tile in map("block"):iterate() do
    self:addBlock(x*tile.width, y*tile.height, tile.width, tile.height)
  end

  self.map = map
end


function Level:addBlock(x, y, w, h)
	local block = {x=x,y=y,w=w,h=h}
	--blocks[#blocks+1] = block
	self.world:add(block, x,y,w,h)

end


function Level:exdraw()
	for _, tile in ipairs(self.tiles) do
		love.graphics.draw(tile.image, tile.x, tile.y, 0, cfg.scale_factor, cfg.scale_factor)
	end
end


function Level:draw()
  --self.map:setDrawRange(self.camera.x,self.camera.y, self.camera.w, self.camera.h)
  self.map:draw()
end


return Level