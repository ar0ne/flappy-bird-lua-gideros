Pipe = Core.class(Sprite)

--[[
	options = {
		level   	 	- reference to level object
		bottom_offset   - offset for land
		speed  		 	- speed of pipes
		level_width  	- width of device
		level_height 	- height of device
		pipe_offset  	- offset between up and bottom pipes
		pipe_scale 	 	- scale of pipe image 
		pipe_end_scale	- scale of up and bottom ends of pipes
		side_offset		- offset from sides
		player_pos_x  	- position of player
	}
--]]
	
function Pipe:init(options)

	self.level 			= options.level
	self.speed 			= options.speed
	self.bottom_offset 	= options.bottom_offset
	self.level_width 	= options.level_width
	self.level_height 	= options.level_height
	self.pipe_offset 	= options.pipe_offset
	self.side_offset 	= options.side_offset
	self.pipe_end_scale = options.pipe_end_scale
	self.pipe_scale 	= options.pipe_scale
	self.player_pos_x 	= options.player_pos_x
	
	self.paused = true
	
	self.point_sound = Sound.new("assets/sounds/sfx_point.mp3")

	self.pipe__texture = Texture.new("assets/images/pipe.png")
	
	self.pipes_up = {
		Bitmap.new(Texture.new("assets/images/pipe-up.png")),
		Bitmap.new(Texture.new("assets/images/pipe-up.png")),
	}
	
	self.pipes_down = {
		Bitmap.new(Texture.new("assets/images/pipe-up.png")),
		Bitmap.new(Texture.new("assets/images/pipe-up.png")),
	}
	
	for i = 1, #self.pipes_up do
		self.pipes_up[i]:setAnchorPoint(0.5, 0.5)
		self.pipes_up[i]:setScale(self.pipe_end_scale, self.pipe_end_scale)
	end
	
	for i = 1, #self.pipes_down do
		self.pipes_down[i]:setAnchorPoint(0.5, 0.5)
		self.pipes_down[i]:setScale(self.pipe_end_scale, -self.pipe_end_scale)
	end
	
	self.pipes_end_width  = self.pipes_down[1]:getWidth()
	self.pipes_end_height = self.pipes_down[1]:getHeight()
		

	self.pipes = {}
	
	if self.level.world ~= nil then	
		self:createBodies()
	end
	
	----- EVENTS --------
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	---------------------
end

function Pipe:getRandomHeight()

	local y_up, y_down
	local H = self.level_height - self.bottom_offset

	y_up = math.random(self.pipes_end_height * 2, H - self.pipes_end_height * 2 - self.pipe_offset)
	y_down = H - y_up - self.pipe_offset
	
	return y_up, y_down
end

function Pipe:createBody(width, height, pos_x, pos_y)

	local body = self.level.world:createBody {
		type = b2.STATIC_BODY
	}
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(width, height)
	body:setPosition(pos_x, pos_y)
		
	local fixture = body:createFixture {
		shape 		= poly, 
		density 	= 1.0, 
		friction 	= 0.1, 
		restitution = 0.2
	}
	
	body.type = "wall"
	body.height = height
	body.width = width
	
	return body
end

--[[
	Fill interval from end of pipe and level border
	@height - height of pipe body
	@x - position of pipe middle 
	@isUp - pipes can be from top and bottom
	@return pipe_fill - array of pipe body sprites
--]]
function Pipe:fillPipe(height, x, isUp)

	local fill_height = math.floor(height - self.pipes_end_height)
	local pipe_fill = {}
	
	for i = 1, fill_height do
		
		pipe_fill[i] = Bitmap.new(self.pipe__texture)
		pipe_fill[i]:setAnchorPoint(0.5, 0.5)
		pipe_fill[i]:setScale(self.pipe_scale, self.pipe_scale)
		
		if isUp then
			pipe_fill[i]:setPosition(x, i)
		else
			pipe_fill[i]:setPosition(x, self.level_height - self.bottom_offset - i)
		end
		
		self:addChild(pipe_fill[i])
	end
	
	return pipe_fill
end


function Pipe:createBodies()

	local h1, h2 = self:getRandomHeight()

	self.pipes[1] = self:createBody(self.pipes_end_width / 2, h1 / 2, self.level_width * 2 , h1 / 2)
	self.pipes[2] = self:createBody(self.pipes_end_width / 2, h2 / 2, self.level_width * 2 , h1 + self.pipe_offset + h2/2)
	
	self.pipes_up[1]:setPosition(self.level_width * 2, h1 / 2 - self.pipes_end_height / 2)
	self.pipes_down[1]:setPosition(self.level_width * 2, h1 + self.pipe_offset + h2 / 2 - self.pipes_end_height / 2)

	self.pipes_fill = {}
	
	for i = 1, 4 do
		self.pipes_fill[i] = {}
	end
	
	local x, _ = self.pipes[1]:getPosition()
	self.pipes_fill[1] = self:fillPipe(h1, x, true)
	self.pipes_fill[2] = self:fillPipe(h2, x, false)
	
	h1, h2 = self:getRandomHeight()
	
	self.pipes[3] = self:createBody(self.pipes_end_width / 2, h1 / 2, self.level_width * 2 + self.side_offset , h1 / 2)
	self.pipes[4] = self:createBody(self.pipes_end_width / 2, h2 / 2, self.level_width * 2 + self.side_offset, h1 + self.pipe_offset + h2/2)
	
	self.pipes_up[2]:setPosition(self.level_width * 2 + self.side_offset, h1 / 2 - self.pipes_end_height / 2)
	self.pipes_down[2]:setPosition(self.level_width * 2 + self.side_offset, h1 + self.pipe_offset + h2/2 - self.pipes_end_height / 2)


	x, _ = self.pipes[3]:getPosition()
	self.pipes_fill[3] = self:fillPipe(h1, x, true)
	self.pipes_fill[4] = self:fillPipe(h2, x, false)


	self:addChild(self.pipes_up[1])
	self:addChild(self.pipes_up[2])
	
	self:addChild(self.pipes_down[1])
	self:addChild(self.pipes_down[2])
	
end

function Pipe:movePipes()

	for k = 1, #self.pipes do
	
		local k_index = 1
		if k >= 3 then
			k_index = 2
		end
	
		if k % 2 ~= 0 then
		
			local x, y = self.pipes[k]:getPosition()
			self.pipes_up[k_index]:setPosition(x, y * 2 - self.pipes_end_height / 2)

			for i = 1, #self.pipes_fill[k] do
				self.pipes_fill[k][i]:setPosition(x, i)
			end
			
		else
		
			local x, y = self.pipes[k]:getPosition()
			self.pipes_down[k_index]:setPosition(x, y - self.pipes[k].height + self.pipes_end_height / 2)

			for i = 1, #self.pipes_fill[k] do
				self.pipes_fill[k][i]:setPosition(x, self.level_height - self.bottom_offset - i)
			end
		
		end
	end
	
end


function Pipe:onEnterFrame(e)

	if not self.paused then
	
		for i = 1, #self.pipes do
		
			local x, y = self.pipes[i]:getPosition()
			
			self.pipes[i]:setPosition( x - self.speed, y)
			
			if x < -self.pipes_end_width / 2 then
			
				if i % 2 ~= 0 then
				
					local h1, h2 = self:getRandomHeight()
					self.pipes[i]   = self:createBody(self.pipes_end_width / 2, h1 / 2, self.side_offset * 2 , h1 / 2)
					self.pipes[i+1] = self:createBody(self.pipes_end_width / 2, h2 / 2, self.side_offset * 2 , h1 + self.pipe_offset + h2 / 2)
					
					-- remove fill from top pipe
					for j = 1, #self.pipes_fill[i] do
						self:removeChild(self.pipes_fill[i][j])
					end
					-- remove fill from bottom pipe
					for j = 1, #self.pipes_fill[i+1] do
						self:removeChild(self.pipes_fill[i+1][j])
					end
					
					-- fill again
					self.pipes_fill[i] 	 = self:fillPipe(h1, x, true)
					self.pipes_fill[i+1] = self:fillPipe(h2, x, false)	
					
					i = i + 1
				end
			end
			
			if x >= self.player_pos_x - self.speed / 2 and x <= self.player_pos_x + self.speed/2 and i % 2 ~= 0 then
				self.level:dispatchEvent(Event.new("pipe_passed"))
				if self.level.isSoundEnabled then
					self.point_sound:play()
				end
			end
			
		end
		
		self:movePipes()
	end

end

