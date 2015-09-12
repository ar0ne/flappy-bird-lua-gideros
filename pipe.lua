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
	}
--]]
	
function Pipe:init( options	)

	self.level = options.level
	self.speed = options.speed
	self.bottom_offset = options.bottom_offset
	self.level_width = options.level_width
	self.level_height = options.level_height
	self.pipe_offset = options.pipe_offset
	self.side_offset = options.side_offset
	
	self.paused = true

	self.pipe__texture = Texture.new("assets/images/pipe.png")
	
	self.pipes_up = {
		Bitmap.new(Texture.new("assets/images/pipe-up.png")),
		Bitmap.new(Texture.new("assets/images/pipe-up.png")),
	}
	
	self.pipes_down = {
		Bitmap.new(Texture.new("assets/images/pipe-down.png")),
		Bitmap.new(Texture.new("assets/images/pipe-down.png")),
	}
	
	for i = 1, #self.pipes_up do
		self.pipes_up[i]:setAnchorPoint(0.5, 0.5)
		self.pipes_up[i]:setScale(options.pipe_end_scale, options.pipe_end_scale)
	end
	
	for i = 1, #self.pipes_down do
		self.pipes_down[i]:setAnchorPoint(0.5, 0.5)
		self.pipes_down[i]:setScale(options.pipe_end_scale, options.pipe_end_scale)
	end
	
	self.pipes_end_width = self.pipes_down[1]:getWidth()
	self.pipes_end_height = self.pipes_down[1]:getHeight()
		

	self.pipes = {}

	self:createBodies()
	
	----- EVENTS --------
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	---------------------
end

function Pipe:getRandomHeight()
	local y_up, y_down
	
	local H = self.level_height - self.bottom_offset

	y_up = math.random(self.pipes_end_height * 2, H - self.pipes_end_height * 2 - self.pipe_offset)
	--y_up = H
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
	
	return body
end

function Pipe:createBodies()

	local h1, h2 = self:getRandomHeight()

	self.pipes[1] = self:createBody(self.pipes_end_width / 2, h1 / 2, self.level_width * 2 , h1 / 2)
	self.pipes[2] = self:createBody(self.pipes_end_width / 2, h2 / 2, self.level_width * 2 , h1 + self.pipe_offset + h2/2)
	
	h1, h2 = self:getRandomHeight()
	
	self.pipes[3] = self:createBody(self.pipes_end_width / 2, h1 / 2, self.level_width * 2 + self.side_offset , h1 / 2)
	self.pipes[4] = self:createBody(self.pipes_end_width / 2, h2 / 2, self.level_width * 2 + self.side_offset, h1 + self.pipe_offset + h2/2)
	
	
end

function Pipe:onEnterFrame(e)

	local h1, h2

	if not self.paused then
		for i = 1, #self.pipes do
			local x, y = self.pipes[i]:getPosition()
			self.pipes[i]:setPosition( x - self.speed, y)
			
			if x < -self.pipes_end_width / 2 then
				if i == 1 or i == 3 then
					local h1, h2 = self:getRandomHeight()
					self.pipes[i]   = self:createBody(self.pipes_end_width / 2, h1 / 2, self.side_offset * 2 , h1 / 2)
					self.pipes[i+1] = self:createBody(self.pipes_end_width / 2, h2 / 2, self.side_offset * 2 , h1 + self.pipe_offset + h2/2)
					i = i + 1
				end
			end
			
		end
	end

end

