Bird = Core.class(Sprite)

--[[

	level 
	pos_x
	pos_y
	level_height
	speed 

--]]

function Bird:init(options)

	self.level = options.level
	self.pos_x = options.pos_x
	self.speed = options.speed
	self.level_height = options.level_height
	
	self.paused = true
	
	self.swooshing_sound = Sound.new("assets/sounds/sfx_swooshing.mp3")
	
	local spritesheet = Texture.new("assets/images/bird.png")
	
	local anim = {
		Bitmap.new(TextureRegion.new(spritesheet, 0,  0, 34, 24)),
		Bitmap.new(TextureRegion.new(spritesheet, 0, 24, 34, 24)),
		Bitmap.new(TextureRegion.new(spritesheet, 0, 48, 34, 24)),
		Bitmap.new(TextureRegion.new(spritesheet, 0, 72, 34, 24)),
	}
		
	local scale = conf.BIRD_SCALE / anim[1]:getWidth()	
	
	for i = 1, #anim do
		anim[i]:setAnchorPoint(0.5, 0.5)
		anim[i]:setScale(scale, scale)
	end
	
	self.radius = anim[1]:getWidth() * 0.45
	
	self.bird_mc = MovieClip.new{
		{ 1,  5, anim[1]},
		{ 6, 10, anim[2]},
		{11, 15, anim[3]},
		{16, 20, anim[4]}
	}
	
	self.bird_mc:gotoAndPlay(1)
	self.bird_mc:setGotoAction(20, 1)
	
	self:addChild(self.bird_mc)
	
	self:setPosition(options.pos_x, options.pos_y)
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
		
end


function Bird:onEnterFrame(event)

	if not self.paused then
	
		local x, y = self.body:getPosition()
		
		if y < 0 then
			self.body:setPosition(x, 0)
		end	
		
		local _, vel_y = self.body:getLinearVelocity()
		
		local angle = math.min((vel_y / 10) * 30 , 90)
		
		self.body.object:setRotation(angle)
		
	end
	
end


function Bird:createBody()

	local body = self.level.world:createBody{
		type = b2.DYNAMIC_BODY
	}
		
	body:setPosition(self:getPosition())
	
	local circle = b2.CircleShape.new(0, 0, self.radius)
	
	local fixture = body:createFixture{
		shape = circle,
		density = 1.0,
		friction = 0,
		restitution = 0.5
	}
	
	body.type = "player"
	self.body = body
	body.object = self
	
end


function Bird:onMouseDown(event)
	
	if not self.paused then
		event:stopPropagation()
		
		if self.level.isSoundEnabled then
			self.swooshing_sound:play()
		end
		
		self.body:setLinearVelocity(0, -self.speed)
		
	end
	
end


