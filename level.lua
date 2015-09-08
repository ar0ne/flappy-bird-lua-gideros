LevelScene = Core.class(Sprite)

function LevelScene:init()

	self.world = b2.World.new(0, conf.GRAVITY, true)
	self.bodies = {}
	
	self.land = Land.new({
		level = self,
		speed = conf.LAND_SPEED,
		scale = conf.LAND_SCALE,
		level_height = conf.HEIGHT,
		level_width = conf.WIDTH,
		
	})
	
	self.bg   = Background.new({
		level = self,
		speed = conf.BG_SPEED,
		level_height = conf.HEIGHT,
		level_width = conf.WIDTH,
		raw_scale = conf.HEIGHT - self.land.land_height
	})
	
	self.bird = Bird.new({
		level = self,
		pos_x = conf.WIDTH / 3,
		pos_y = conf.HEIGHT / 2,
		level_height = conf.HEIGHT,
		speed = conf.BIRD_SPEED
	})
	
	--[[
	self.pipe = Pipe.new({
		level = 			self,
		bottom_offset = 	conf.LAND_OFFSET,
		speed = 			conf.PIPE_SPEED,
		stage_width = 		conf.WIDTH,
		stage_height = 		conf.HEIGHT,
		pipe_offset = 		conf.PIPE_OFFSET,
		pipe_scale = 		conf.PIPE_SCALE,	
		pipe_end_scale = 	conf.PIPE_END_SCALE
	})
	--]]
	
	self.score = Score.new({
		scale = conf.SCORE_SCALE,
		level_width = conf.WIDTH
	})
	self.splashscreen = Splashscreen.new({
		pos_x = conf.WIDTH / 2,
		pos_y = conf.HEIGHT / 2,
		scale = conf.SPLASHSCREEN_SCALE,
	})
	
	
	self:addChild(self.bg)
	self:addChild(self.land)
	--self:addChild(self.pipe)
    self:addChild(self.bird)
	self:addChild(self.score)
	self:addChild(self.splashscreen)
	
	----- DEBUG ---------
	-- [[
	local debugDraw = b2.DebugDraw.new()
	self.world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)
	--]]
	---------------------

	
	------ EVENTS -------
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self.world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
	
	---------------------
	
end

function LevelScene:onEnterFrame(event)

	if not self.paused then
		self.world:step(1/60, 8, 3)
		local body
		for i = 1, #self.bodies do
			body = self.bodies[i]
			body.object:setPosition(body:getPosition())
			
			body.object:setRotation(math.deg(body:getAngle()))
			--body.object:setRotation(math.deg(0))
		end
		
		if self.splashscreen.showed == true then
			--self.pipe.paused = false
			self.bird.paused = false
			self.bird:createBody()
			self.splashscreen.showed = false
			self.bg.paused = false
		end
		
		-- Increment game score
		--print(math.floor(self.tube.cur_position))
		--[[
		if math.floor(self.tube.cur_position) < conf.WIDTH / 3 + 2 and  math.floor(self.tube.cur_position) > conf.WIDTH / 3 - 1 then
			self.score:updateScore(self.score:getScore() + 1)
			self.sounds:play("point")
		end
		--]]
		 
	end
end

function LevelScene:onBeginContact(event)
	local fixtureA = event.fixtureA
	local fixtureB = event.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB:getBody()
	
	if bodyA.type and bodyB.type then
		if ((bodyA.type == "player" and bodyB.type == "wall") or
			(bodyB.type == "player" and bodyA.type == "wall")) then
			print("Game Over " .. math.random(0, 10))
			sceneManager:changeScene("level", conf.TRANSITION_TIME,  SceneManager.fade)
			self.paused = true
		end
	end
end
