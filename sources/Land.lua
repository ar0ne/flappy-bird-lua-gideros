Land = Core.class(Sprite)

--[[

	level
	speed
	scale
	level_height 
	level_width

--]]
function Land:init(options)

	self.paused 		= true
	self.level 			= options.level
	self.land_speed 	= options.speed
	self.level_height 	= options.level_height
	self.level_width 	= options.level_width
	
	self.land_images = {
		Bitmap.new(Texture.new("assets/images/land.png")),
		Bitmap.new(Texture.new("assets/images/land.png")),
	}
	
	for i = 1, #self.land_images do 
		self.land_images[i]:setScale(options.scale, options.scale)
		self.land_images[i]:setAnchorPoint(0, 0.5)
		self:addChild(self.land_images[i])
	end
		
	self.land_width 	= self.land_images[1]:getWidth()
	self.land_height 	= self.land_images[1]:getHeight()
	
	self.pos_y = options.level_height - self.land_height/2
	
	self.land_images[1]:setPosition(0,  self.pos_y)
	self.land_images[2]:setPosition(self.land_width - 2, self.pos_y )
		
	if self.level.world ~= nil then	
		self:createBody()
	end
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Land:createBody()

	local body = self.level.world:createBody {
		type = b2.STATIC_BODY
	}
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(self.land_width * 2, self.land_height / 2)
	body:setPosition(self.level_width , self.level_height - self.land_height/2)
		
	local fixture = body:createFixture {
		shape = poly, 
		density = 1.0, 
		friction = 0.1, 
		restitution = 0.2
	}
	
	body.type = "wall"
end

function Land:onEnterFrame(event)
	if not self.paused then
		for i = 1, #self.land_images do
			local pos_x = self.land_images[i]:getX()
			self.land_images[i]:setX(pos_x - self.land_speed)
			
			-- if some image hide from screen then replace it
			if pos_x + self.land_width < 0  then
				self.land_images[i]:setX(self.land_width - 10)
			end
		end
	end
end
