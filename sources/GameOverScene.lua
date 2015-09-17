GameOverScene = Core.class(Sprite)

--[[

	@params - score from last game round

--]]

function GameOverScene:init(params)
	
	self.level_width = conf.WIDTH


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
		
	self:addChild(self.land)
	self:addChild(self.bg)

	-----------------------

	self.scoreboard = Bitmap.new(Texture.new("assets/images/scoreboard.png"))
	self.scoreboard:setAnchorPoint(0.5, 0.5)
	self.scoreboard:setScale(conf.SCOREBOARD_SCALE, conf.SCOREBOARD_SCALE)
	self.scoreboard:setPosition(conf.WIDTH / 2, conf.HEIGHT / 2)
	
	local replay = Bitmap.new(Texture.new("assets/images/replay.png"))
	replay:setAnchorPoint(0.5, 0.5)
	replay:setScale(conf.REPLAY_SCALE, conf.REPLAY_SCALE)

	self.replay_button = Button.new(replay)
	self.replay_button:setPosition(conf.WIDTH / 2 - replay:getWidth() / 2, conf.HEIGHT / 2 + self.scoreboard:getHeight() / 3)
	
	self.numbers = {
		Texture.new("assets/images/fonts/small/font_small_0.png"),
		Texture.new("assets/images/fonts/small/font_small_1.png"),
		Texture.new("assets/images/fonts/small/font_small_2.png"),
		Texture.new("assets/images/fonts/small/font_small_3.png"),
		Texture.new("assets/images/fonts/small/font_small_4.png"),
		Texture.new("assets/images/fonts/small/font_small_5.png"),
		Texture.new("assets/images/fonts/small/font_small_6.png"),
		Texture.new("assets/images/fonts/small/font_small_7.png"),
		Texture.new("assets/images/fonts/small/font_small_8.png"),
		Texture.new("assets/images/fonts/small/font_small_9.png"),
	}
	
	-----------------------
	
	if params ~= nil and type(params) == "number" and params > 0 then
		self.medal_gold = Bitmap.new(Texture.new("assets/images/medal_gold.png"))
		self.medal_silver = Bitmap.new(Texture.new("assets/images/medal_silver.png"))
		self.medal_platinum = Bitmap.new(Texture.new("assets/images/medal_platinum.png"))
	else
		params = 0
	end
	
	self:addChild(self.scoreboard)
	self:addChild(self.replay_button)
	
	--print("SCORE: " .. params)
	self:showScore(params)
	
	self.replay_button:addEventListener("click", function() 
		sceneManager:changeScene("level", conf.TRANSITION_TIME,  SceneManager.fade, easing.inOutQuadratic)
	end)

end

function GameOverScene:showScore(score)
	
	local score_imgs = {}
	score_imgs = self:getScoreImages(score)
	
	local number_scale = conf.GAME_OVER_NUMBER_SCALE
	
	local pos_y = conf.HEIGHT / 2 - score_imgs[1]:getHeight() * 3
	
	local image_width = self.numbers[1]:getWidth()
	
	for i = 1, #score_imgs do
		
		local num = score_imgs[i]
		
		num:setScale(number_scale, number_scale)
		num:setAnchorPoint(0.5, 0.5)
		
		if #score_imgs == 1 then
			score_imgs[i]:setPosition(self.level_width / 2 + self.scoreboard:getWidth() / 4 + image_width * 2, pos_y)
		elseif #score_imgs == 2 then
			score_imgs[i]:setPosition(self.level_width / 2 + self.scoreboard:getWidth() / 4 + image_width * 2 + math.pow((-1), i) * image_width, pos_y)
		elseif #score_imgs == 3 then
			score_imgs[i]:setPosition(self.level_width / 2 + self.scoreboard:getWidth() / 4 + image_width * 2 + (i - 2) * image_width, pos_y)
		end
		
		self:addChild(num)
	end
	
end

function GameOverScene:getScoreImages(num)
	local answer = {}
	
	if num == 0 then
		return {Bitmap.new(self.numbers[1])}
	end
	
	while num > 0 do
		answer[#answer + 1] = num % 10
		num = math.floor(num / 10)
	end
	
	local ret = {}
	
	for i = #answer, 1, -1 do
		ret[#ret + 1] = Bitmap.new(self.numbers[answer[i] + 1])
	end	
		
	return ret	
end