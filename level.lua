require "box2d"

level = Core.class(Sprite)

function level:init()

	self.world = b2.World.new(0, conf.GRAVITY, true)
	self.bodies = {}
	
	self.bg = Background.new()
	self.land = Land.new(self)
	
	self.bird = Bird.new(self, conf.WIDTH / 3 , conf.HEIGHT / 2)
    self.tube = Tube.new(self)
	self.score = Score.new(self)
	
	self.sounds = Sound.new()
	self.sounds:add("point", "assets/sounds/sfx_point.mp3")
	self.sounds:add("touch", "assets/sounds/sfx_swooshing.mp3")
	self.sounds:add("die", "assets/sounds/sfx_die.mp3")
	self.sounds:add("wing", "assets/sounds/sfx_wing.mp3")
	self.sounds:add("hit", "assets/sounds/sfx_hit.mp3")
	
	self.sounds:on()
	
	self:addChild(self.bg)
	self:addChild(self.land)
    self:addChild(self.bird)
	self:addChild(self.score)
	
	----- DEBUG ---------
	local debugDraw = b2.DebugDraw.new()
	self.world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)
	---------------------
	--[[
	
	local body = self.world:createBody{type = b2.STATIC_BODY}
	body:setPosition(0, 0)
	
	local chain = b2.ChainShape.new()
	chain:createLoop(
		0, 0,
		conf.WIDTH, 0,
		conf.WIDTH, conf.HEIGHT,
		0, conf.HEIGHT
	)
	
	local fixture = body:createFixture{
		shape = chain,
		density = 1.0,
		friction = 1,
		restitution = 1
	}
	--]]
	
	--[[
	body.type = "wall"
	self.body = body
	body.object = self
	
	]]
	---------------
	

	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self.world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
	
end

function level:onEnterFrame(event)
	if not self.paused then
		self.world:step(1/60, 8, 3)
		local body
		for i = 1, #self.bodies do
			body = self.bodies[i]
			body.object:setPosition(body:getPosition())
			
			--body.object:setRotation(math.deg(body:getAngle()))
			body.object:setRotation(math.deg(0))
		end
		
		-- Increment game score
		--print(math.floor(self.tube.cur_position))
		if math.floor(self.tube.cur_position) < conf.WIDTH / 3 + 2 and  math.floor(self.tube.cur_position) > conf.WIDTH / 3 - 1 then
			self.score:updateScore(self.score:getScore() + 1)
			self.sounds:play("point")
		end
		 
	end
end

function level:onBeginContact(event)
	local fixtureA = event.fixtureA
	local fixtureB = event.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB:getBody()
	
	if bodyA.type and bodyB.type then
		if ((bodyA.type == "player" and bodyB.type == "wall") or
			(bodyB.type == "player" and bodyA.type == "wall")) then
			print("Game Over")
		end
	end
end