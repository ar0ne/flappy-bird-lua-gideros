Pipe = Core.class(Sprite)

--[[
	options = {
		level   	 	- reference to level object
		bottom_offset   - offset for land
		speed  		 	- speed of pipes
		stage_width  	- width of device
		stage_height 	- height of device
		pipe_offset  	- offset between up and bottom pipes
		pipe_scale 	 	- scale of pipe image 
		pipe_end_scale	- scale of up and bottom ends of pipes
	}
--]]
	
function Pipe:init( options	)

	self.level = options.level
	self.paused = true

	self.pipe__texture = Texture.new("assets/images/pipe.png")
	
	self.pipe_up = Bitmap.new(Texture.new("assets/images/pipe-up.png"))
	self.pipe_down = Bitmap.new(Texture.new("assets/images/pipe-down.png"))
	
	self.pipe_up:setAnchorPoint(0.5, 0.5)
	self.pipe_down:setAnchorPoint(0.5, 0.5)
	
	-- hide from screen
	self.pipe_up:setPosition(-100, -100)
	self.pipe_down:setPosition(-100, -100)
	
	self.pipe_end_scale = options.pipe_end_scale
	self.pipe_up:setScale(self.pipe_end_scale, self.pipe_end_scale )
	self.pipe_down:setScale(self.pipe_end_scale, self.pipe_end_scale )
	
	self.speed = options.speed
	self.bottom_offset = options.bottom_offset
	self.stage__width = options.stage_width
	self.stage__height = options.stage_height
	self.pipe_offset = options.pipe_offset
	self.pipe_scale = options.pipe_scale

	
	self.pipe__width = self.pipe_scale * self.pipe__texture:getWidth()
	self.pipe_up_and_down_end__width = self.pipe_up:getWidth()
	self.pipe_up_and_down_end__height = self.pipe_down:getHeight()
	
	self.cur_position = self.stage__width
	
	self.pipes_up, self.pipes_down = {}, {}
	
	self.body_pipe_end_up, self.body_pipe_end_down = nil, nil
	
	self.pipe_up__height, self.pipe_down__height = self:getRandomPipeHeights()
	
	self:addChild(self.pipe_up)
	self:addChild(self.pipe_down)
	
	self:createBody()
	
	----- EVENTS --------
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	---------------------
end

function Pipe:onEnterFrame(e)

	if not self.paused then
	
		if self.pipes_up and self.pipes_down then
			for i = 1, #self.pipes_up do
				self.pipes_up[i]:getParent():removeChild(self.pipes_up[i])
			end
			for i = 1, #self.pipes_down do
				self.pipes_down[i]:getParent():removeChild(self.pipes_down[i])
			end
		end
				
		-- pipes on the screen 
		if self.cur_position > - self.pipe_up_and_down_end__width then
			self.cur_position = self.cur_position - self.speed
			
		-- pipes left the screen
		else 
			self.cur_position = self.stage__width + self.pipe_up_and_down_end__width / 2
			
			self.pipe_up__height, self.pipe_down__height = self:getRandomPipeHeights()
			self.pipes_up, self.pipes_down = {}, {}

		end
		
		--self:moveBody()
		self:draw()
		
		
	end

end

function Pipe:draw()

	for i = 1, self.pipe_up__height - 1 do
		self.pipes_up[i] = Bitmap.new(self.pipe__texture)
		self.pipes_up[i]:setScale(self.pipe_scale, self.pipe_scale)
		self.pipes_up[i]:setAnchorPoint(0.5, 0)
		self.pipes_up[i]:setPosition(self.cur_position, i )
		self:addChild(self.pipes_up[i])
	end
	
	local down_pipes_y = math.floor(self.pipe_up__height + self.pipe_offset + self.pipe_up_and_down_end__height * 2)
	
	for i = 1, self.pipe_down__height - 1 do
		self.pipes_down[i] = Bitmap.new(self.pipe__texture)
		self.pipes_down[i]:setScale(self.pipe_scale, self.pipe_scale)
		self.pipes_down[i]:setAnchorPoint(0.5, 0)
		self.pipes_down[i]:setPosition(self.cur_position, down_pipes_y + i - 1)
		self:addChild(self.pipes_down[i])
	end
			
	self.body_pipe_end_up:setPosition(self.cur_position, self.pipe_up__height + self.pipe_up_and_down_end__height / 2)
	self.body_pipe_end_down:setPosition(self.cur_position, down_pipes_y - self.pipe_up_and_down_end__height / 2)
	self.body_pipe_up:setPosition(self.cur_position, self.pipe_up__height / 2)	
	
end

function Pipe:getRandomPipeHeights()

	local min = self.pipe_up_and_down_end__height 
	local max = self.stage__height - (self.bottom_offset + 2 * min + self.pipe_offset)
	
	local up_h = math.floor( math.random( min, max ))
	local down_h = self.stage__height - ( up_h + 2 * min + self.pipe_offset + self.bottom_offset)
	
	return up_h, down_h
	
end

function Pipe:moveBody()
	if self.body_up or self.body_down then
		self.body_up:setPosition(self.cur_position, 0)
		self.body_down:setPosition(self.cur_position,self.pipe_up__height + self.pipe_offset + self.pipe_up_and_down_end__height)
	end
end

function Pipe:createBody()

	local body_pipe_end_up = self.level.world:createBody {
		type = b2.STATIC_BODY
	}
	
	local poly_pipe_end_up  = b2.PolygonShape.new()
	
	poly_pipe_end_up :setAsBox(self.pipe_up_and_down_end__width / 2, self.pipe_up_and_down_end__height / 2)
	
	body_pipe_end_up:setPosition(self.cur_position, self.pipe_up__height + self.pipe_up_and_down_end__height / 2)
	body_pipe_end_up:setAngle(math.rad(self:getRotation()))
		
	local fixture_up = body_pipe_end_up:createFixture {
		shape = poly_pipe_end_up , 
		density = 1.0, 
		friction = 0.1, 
		restitution = 0.2
	}
		
	body_pipe_end_up.type = "wall"
	self.body_pipe_end_up = body_pipe_end_up
	body_pipe_end_up.object = self.pipe_up
	
	table.insert(self.level.bodies, self.body_pipe_end_up)
	
	--------------
	
	local body_pipe_end_down = self.level.world:createBody {
		type = b2.STATIC_BODY
	}
	
	local poly_pipe_end_down = b2.PolygonShape.new()
	
	poly_pipe_end_down:setAsBox(self.pipe_up_and_down_end__width / 2, self.pipe_up_and_down_end__height / 2)
	
	body_pipe_end_down:setPosition(self.cur_position, self.pipe_up__height + self.pipe_up_and_down_end__height * 1.5 + self.bottom_offset)
	body_pipe_end_down:setAngle(math.rad(self:getRotation()))
		
	local fixture_down = body_pipe_end_down:createFixture {
		shape = poly_pipe_end_down, 
		density = 1.0, 
		friction = 0.1, 
		restitution = 0.2
	}
	
	body_pipe_end_down.type = "wall"
	self.body_pipe_end_down = body_pipe_end_down
	body_pipe_end_down.object = self.pipe_down
	
	table.insert(self.level.bodies, self.body_pipe_end_down)
	---------------------
	
	local body_pipe_up = self.level.world:createBody {
		type = b2.STATIC_BODY
	}
	
	local poly_pipe_up  = b2.PolygonShape.new()
	
	poly_pipe_up:setAsBox(self.pipe__width / 2, self.pipe_up__height / 2)
	
	body_pipe_end_up:setPosition(self.cur_position, self.pipe_up__height / 2)
	body_pipe_end_up:setAngle(math.rad(self:getRotation()))
		
	local fixture_up = body_pipe_up:createFixture {
		shape = poly_pipe_up , 
		density = 1.0, 
		friction = 0.1, 
		restitution = 0.2
	}
		
	body_pipe_up.type = "wall"
	self.body_pipe_up = body_pipe_up
	body_pipe_up.object = self.pipe_up
	
	table.insert(self.level.bodies, self.body_pipe_up)
	
	--------------
	--[[
	local body_pipe_end_down = self.level.world:createBody {
		type = b2.STATIC_BODY
	}
	
	local poly_end_down = b2.PolygonShape.new()
	
	
	poly_end_down:setAsBox(self.pipe_up_and_down_end__width / 2, self.pipe_up_and_down_end__height / 2)
	
	body_pipe_end_down:setPosition(self.cur_position, self.pipe_up__height + self.pipe_up_and_down_end__height * 1.5 + self.bottom_offset)
	body_pipe_end_down:setAngle(math.rad(self:getRotation()))
		
	local fixture_down = body_pipe_end_down:createFixture {
		shape = poly_end_down, 
		density = 1.0, 
		friction = 0.1, 
		restitution = 0.2
	}
	
	body_pipe_end_down.type = "wall"
	self.body_pipe_end_down = body_pipe_end_down
	body_pipe_end_down.object = self.pipe_down
	
	table.insert(self.level.bodies, self.body_pipe_end_down)
	--]]
	
	
end