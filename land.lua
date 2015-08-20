
local function createBody(level, x, y, hx, hy)

	local body = level.world:createBody {
		type = b2.STATIC_BODY
	}
	
	local poly = b2.PolygonShape.new()
	
	poly:setAsBox(hx, hy)
	
	body:setPosition(x, y)
		
	local fixture = body:createFixture {
		shape = poly, 
		density = 1.0, 
		friction = 0.1, 
		restitution = 0.2
	}
	
	body.type = "wall"
	
end

--------------------------------

Land = Core.class(Sprite)

function Land:init(level)

	self.level = level
	
	self.land_speed = conf.LAND_SPEED
	
	self.land_images = {
		Bitmap.new(Texture.new("assets/images/land.png")),
		Bitmap.new(Texture.new("assets/images/land.png")),
	}
	
	local land_scale = conf.LAND_SCALE
	
	self.land_width = self.land_images[1]:getWidth()
	self.land_height = self.land_images[1]:getHeight()
		
	for i = 1, #self.land_images do 
		self.land_images[i]:setScale(land_scale, land_scale)
		self.land_images[1]:setPosition((i - 1) * self.land_width , conf.HEIGHT - self.land_height )
		self:addChild(self.land_images[i])
	end
	
	createBody(self.level, conf.WIDTH / 2, conf.HEIGHT - self.land_height/2, self.land_width, self.land_height/2)
	
	self:addEventListener(Event.ADDED_TO_STAGE, self.onAddedToStage, self)
	self:addEventListener(Event.REMOVED_FROM_STAGE, self.onRemovedFromStage, self)
	
end

function Land:onAddedToStage(event)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Land:onRemovedFromStage(event)
	self.removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Land:onEnterFrame(event)
	for i = 1, #self.land_images do
		self.land_images[i]:setPosition(self.land_images[i]:getX() - self.land_speed + 1, conf.HEIGHT - self.land_height)
		
		-- if some image hide from screen then replace it
		if self.land_images[i]:getX() + self.land_width < 0  then
			self.land_images[i]:setX(self.land_width )
		end
	end
end

