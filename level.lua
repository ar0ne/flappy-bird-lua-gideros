require "box2d"

level = Core.class(Sprite)

function level:init()

	self.world = b2.World.new(0, conf.GRAVITY, true)
	self.bodies = {}
	
	local bird = Bird.new(self, conf.WIDTH * 0.3 , conf.HEIGHT / 2)
    local bg = Background.new()
    local tube = Tube.new(self)
	local land = Land.new(self)
	self.score = Score.new(self)
	
	self:addChild(bg)
	self:addChild(land)
    self:addChild(bird)
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
		--print(#self.bodies)
		for i = 1, #self.bodies do
			body = self.bodies[i]
			body.object:setPosition(body:getPosition())
			--body.object:setRotation(math.deg(body:getAngle()))
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