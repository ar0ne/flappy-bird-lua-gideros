Bird = Core.class(Sprite)

function Bird:init(level, x, y)

	self.level = level
	self:setPosition(x, y)
	self.pos_x = x
	
	local spritesheet = Texture.new("assets/images/bird.png")
	
	self.anim = {
		Bitmap.new(TextureRegion.new(spritesheet, 0,  0, 34, 24)),
		Bitmap.new(TextureRegion.new(spritesheet, 0, 24, 34, 24)),
		Bitmap.new(TextureRegion.new(spritesheet, 0, 48, 34, 24)),
		Bitmap.new(TextureRegion.new(spritesheet, 0, 72, 34, 24)),
	}
	
	self:addChild(self.anim[1])
	
	for i = 1, #self.anim do
		self.anim[i]:setAnchorPoint(0.5, 0.5)
		self.anim[i]:setScale(conf.BIRD_SCALE, conf.BIRD_SCALE)
	end
	
	self.frame = 1
	self.nframes = #self.anim
	self.subframe = 0
	
	self:createBody()
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	--self:addEventListener(Event.MOUSE_DOWN, self.jump, self)
	self:addEventListener(Event.ADDED_TO_STAGE, self.onAddedToStage, self)
	self:addEventListener(Event.REMOVED_FROM_STAGE, self.onRemovedFromStage, self)
	
	local timer = Timer.new(200)
	timer:addEventListener(Event.TIMER, self.jump, self)
	 
	self:addEventListener(Event.MOUSE_DOWN, function()
		self:jump()
		timer:start()
	end)
	 
	self:addEventListener(Event.MOUSE_UP, function()
		timer:stop()
	end)
	
end

function Bird:onAddedToStage(event)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Bird:onRemovedFromStage(event)
	self.removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Bird:onEnterFrame(event)

	self:birdAnimation()
	
	local x, y = self.body:getPosition()
	if self.body and x ~= self.pos_x then
		self.body:setPosition(self.pos_x, y)
	end
	
	local vel_x, vel_y = self.body:getLinearVelocity()
	--print(vel_x, vel_y)
	
	if vel_y > 10 then
		self.body:setLinearVelocity(vel_x, 10)
	elseif vel_y < -10 then
		self.body:setLinearVelocity(vel_x, -10)
	end
	
	local x, y = self.body:getPosition()
	
	if y < 0 then
		self.body:setPosition(x, 0)
	end	
	
end

function Bird:birdAnimation()
		-- bird animation
	self.subframe = self.subframe + 1

	if self.subframe > 4 then
		self:removeChild(self.anim[self.frame])
		
		self.frame = self.frame + 1
		if self.frame > self.nframes then
			self.frame = 1
		end

		self:addChild(self.anim[self.frame])
		
		self.subframe = 0
	end
end

function Bird:createBody()

	local body = self.level.world:createBody{
		type = b2.DYNAMIC_BODY
	}
	
	local radius = self.anim[1]:getWidth() / 2
	
	body:setPosition(self:getPosition())
	--body:setAngle(math.rad(self:getRotation()))
	
	local circle = b2.CircleShape.new(0, 0, radius)
	
	local fixture = body:createFixture{
		shape = circle,
		density = 1.0,
		friction = 0,
		restitution = 0.5
	}
	
	body.type = "player"
	self.body = body
	body.object = self
	
	table.insert(self.level.bodies, body)
end

function Bird:jump()
	--event:stopPropagation()
	local x, y = self.body:getPosition()
	if y < conf.HEIGHT then
		if y > 100 then
			self.body:applyLinearImpulse(0, -conf.BIRD_SPEED, self.pos_x, y)
		elseif y > 50 then
			self.body:applyLinearImpulse(0, -conf.BIRD_SPEED/2, self.pos_x, y)
		end
		self.level.sounds:play("touch")
	end
	
end


