LevelScene = Core.class(Sprite)

function LevelScene:init()

	self.world = b2.World.new(0, conf.GRAVITY, true)
	self.bodies = {}
	
	self.land = Land.new{
		level = self,
		speed = conf.LAND_SPEED,
		scale = conf.LAND_SCALE,
		level_height = conf.HEIGHT,
		level_width = conf.WIDTH,
	}
	
	self.bg   = Background.new{
		level = self,
		speed = conf.BG_SPEED,
		level_height = conf.HEIGHT,
		level_width = conf.WIDTH,
		raw_scale = conf.HEIGHT - self.land.land_height
	}
	
	self.bird = Bird.new{
		level = self,
		pos_x = conf.BIRD_POS_X,
		pos_y = conf.HEIGHT / 2,
		level_height = conf.HEIGHT,
		speed = conf.BIRD_SPEED
	}
	
	-- [[
	self.pipe = Pipe.new({
		level = 			self,
		bottom_offset = 	self.land.land_height,
		side_offset =		conf.PIPE_SIDE_OFFSET,
		speed = 			conf.PIPE_SPEED,
		level_width = 		conf.WIDTH,
		level_height = 		conf.HEIGHT,
		pipe_offset = 		conf.PIPE_OFFSET,
		pipe_scale = 		conf.PIPE_SCALE,	
		pipe_end_scale = 	conf.PIPE_END_SCALE,
		player_pos_x =		conf.BIRD_POS_X
	})
	--]]
	
	self.score = Score.new{
		scale 		= conf.SCORE_SCALE,
		level_width = conf.WIDTH
	}
	
	self.splashscreen = Splashscreen.new{
		pos_x = conf.WIDTH / 2,
		pos_y = conf.HEIGHT / 2,
		scale = conf.SPLASHSCREEN_SCALE,
	}
	
	
	self:addChild(self.bg)
	self:addChild(self.land)
	self:addChild(self.pipe)
    self:addChild(self.bird)
	self:addChild(self.score)
	self:addChild(self.splashscreen)
	
	----- DEBUG ---------
	--[[
	local debugDraw = b2.DebugDraw.new()
	self.world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)
	--]]
	---------------------

	
	------ EVENTS -------
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener("pipe_passed", self.onPipePassed, self)
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
		end
		
		if self.splashscreen.showed == true then
			self.pipe.paused = false
			self.bird.paused = false
			self.bird:createBody()
			self.splashscreen.showed = false
			self.bg.paused = false
		end
		 
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
			self.pipe.paused = true
			--self.paused = true
			self.land.paused = true
			self.bg.paused = true
			self.bird.paused = true
			sceneManager:changeScene("level", conf.TRANSITION_TIME,  SceneManager.fade)
		end
	end
end

function LevelScene:onPipePassed(event)
	-- Increment game score
	self.score:updateScore(self.score:getScore() + 1)
end
