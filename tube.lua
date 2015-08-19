Tube = Core.class(Sprite)

function Tube:init(level)
	
	self.level = level
	
	self.pipe_texture = Texture.new("assets/images/pipe.png")
	self.pipe_down = Bitmap.new(Texture.new("assets/images/pipe-down.png"))
	self.pipe_up = Bitmap.new(Texture.new("assets/images/pipe-up.png"))
		
	self.speed = conf.TUBE_SPEED
	self.stage_width = conf.WIDTH
	self.stage_height = conf.HEIGHT
	self.offset = conf.TUBE_OFFSET
	
	local pipe_scale = 1.4
	
	self.pipe_down:setAnchorPoint(0.5, 0)
	self.pipe_up:setAnchorPoint(0.5, 0)
	
	self.pipe_down:setScale(pipe_scale, pipe_scale)
	self.pipe_up:setScale(pipe_scale, pipe_scale)
	
	self.cur_position = self.stage_width
	
	self.pipe__top, self.pipe__bottom = self:getRandomTubeHeights()
	
	self.pipes_up = {}
	self.pipes_down = {}
	
	self:setPipesBodies()
	
	--------------
	self:createBody()
	
	--------------
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

	stage:addChild(self.pipe_down)
	stage:addChild(self.pipe_up)
	
end

function Tube:onEnterFrame(event)
	
	if self.cur_position then

		if self.cur_position > - self.pipe_down:getWidth() / 2 then
			self.cur_position = self.cur_position - self.speed
			self.body_up:setPosition(self.cur_position, (self.pipe__top + self.pipe_up:getHeight()) / 2)
			local bottom_height = self.stage_height - self.pipe__bottom + self.pipe_down:getHeight()
			self.body_down:setPosition(self.cur_position, self.pipe__bottom + bottom_height / 2)
		else
			self.cur_position = self.stage_width + self.pipe_down:getWidth() / 2
			
			for i = 1, #self.pipes_up do
				stage:removeChild(self.pipes_up[i])
			end
			for i = 1, #self.pipes_down do
				stage:removeChild(self.pipes_down[i])
			end
			self.pipes_up, self.pipes_down = {}, {}
			self.pipe__top, self.pipe__bottom = self:getRandomTubeHeights()
			
			self:setPipesBodies()
			
			-- @TODO: how to check if last cell is not our tube
			table.remove(self.level.bodies)
			table.remove(self.level.bodies)
			
			self:createBody()
		end
	
		self:draw()
	end
	
end

function Tube:draw()
	self.pipe_down:setPosition(self.cur_position, self.pipe__top)
	self.pipe_up:setPosition  (self.cur_position, self.pipe__bottom)

	for i = 1, self.pipe__top - 1 do
		self.pipes_up[i]:setPosition(self.cur_position, i)
		stage:addChild(self.pipes_up[i])
	end
	
	local down_pipes_length = math.floor(self.pipe__bottom + self.pipe_down:getHeight() )
	
	for i = 1, down_pipes_length - 1 do
		self.pipes_down[i]:setPosition(self.cur_position, i + down_pipes_length - 1)
		stage:addChild(self.pipes_down[i])
	end
	
end

function Tube:getRandomTubeHeights()
	local up = math.random(self.stage_height * 0.15, self.stage_height * 0.5) 
	local down = up + self.offset
	return up, down
end

function Tube:setPipesBodies()
	for i = 1, self.pipe__top - 1 do
		self.pipes_up[i] = Bitmap.new(self.pipe_texture)
		self.pipes_up[i]:setAnchorPoint(0.5, 0)
	end
	
	local down_pipes_length = math.floor(self.pipe__bottom + self.pipe_down:getHeight())
	
	for i = 1, down_pipes_length - 1 do
		self.pipes_down[i] = Bitmap.new(self.pipe_texture)
		self.pipes_down[i]:setAnchorPoint(0.5, 0)
	end
	
end

function Tube:createBody()
	local body_up = self.level.world:createBody {
		type = b2.STATIC_BODY
	}
	
	local poly_up = b2.PolygonShape.new()
	
	poly_up:setAsBox(self.pipe_up:getWidth()/2, (self.pipe__top + self.pipe_up:getHeight()) / 2)
	
	body_up:setPosition(self.cur_position, (self.pipe__top + self.pipe_up:getHeight()) / 2)
	body_up:setAngle(math.rad(self:getRotation()))
		
	local fixture_up = body_up:createFixture {
		shape = poly_up, 
		density = 1.0, 
		friction = 0.1, 
		restitution = 0.2
	}
	
	body_up.type = "wall"
	self.body_up = body_up
	body_up.object = self
	
	table.insert(self.level.bodies, body_up)
	
	--------------
	
	local body_down = self.level.world:createBody {
		type = b2.STATIC_BODY
	}
	
	local poly_down = b2.PolygonShape.new()
	
	local bottom_height = self.stage_height - self.pipe__bottom + self.pipe_down:getHeight()
	poly_down:setAsBox(self.pipe_down:getWidth()/2, bottom_height / 2)
	
	body_down:setPosition(self.cur_position, self.pipe__bottom + bottom_height / 2)
	body_down:setAngle(math.rad(self:getRotation()))
		
	local fixture_down = body_down:createFixture {
		shape = poly_down, 
		density = 1.0, 
		friction = 0.1, 
		restitution = 0.2
	}
	
	body_down.type = "wall"
	self.body_down = body_down
	body_down.object = self
	
	table.insert(self.level.bodies, body_down)
	

end