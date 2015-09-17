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
		
	for i = 1, #anim do
		anim[i]:setAnchorPoint(0.5, 0.5)
		anim[i]:setScale(conf.BIRD_SCALE, conf.BIRD_SCALE)
	end
	
	self.radius = anim[1]:getWidth() * 0.9 / 2
	
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
	self:addEventListener(Event.MOUSE_DOWN, self.jump, self)
		
end



function Bird:onEnterFrame(event)

	if not self.paused then
	
		local x, y = self.body:getPosition()
		
		if self.body and x ~= self.pos_x then
			self.body:setPosition(self.pos_x, y)
		end
		
		local vel_x, vel_y = self.body:getLinearVelocity()
		--print(vel_y)
		
		if vel_y < -15 then
			self.body:setLinearVelocity(0, -15 )
		elseif vel_y > 15 then
			self.body:setLinearVelocity(0, 15 )
		end
		
		if y < 0 then
			self.body:setPosition(x, 0)
		end	
		
		local angle = 0
		
		if vel_y < 0 then
			angle = math.min(vel_y / -10, -10)
		elseif vel_y >= 10 then
			angle = 90
		elseif vel_y >= 0 and vel_y < 5 then
			angle = math.min((vel_y / 10) * 10 , 10)
		else
			angle = math.min((vel_y / 10) * 90 , 90)
		end
		
		
		
		--print(vel_y .. " " .. angle)
		
		self.body.object:setRotation(angle)
	end
	
end


-- [[
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
	
	table.insert(self.level.bodies, body)
end

--]]

function Bird:jump()
	
	if not self.paused then
	
		if self.level.isSoundEnabled then
			self.swooshing_sound:play()
		end
		
		local x, y = self.body:getPosition()
		
		local _, vel_y = self.body:getLinearVelocity()
		--print("JUMP " .. vel_y)

		
		
		if vel_y < -25 then
			self.body:setLinearVelocity(0, -15 )
		elseif vel_y > 10 then
			self.body:setLinearVelocity(0, -10 )
		else
			self.body:applyLinearImpulse(0, -self.speed , self.pos_x, y)
		end

	end
	
end


