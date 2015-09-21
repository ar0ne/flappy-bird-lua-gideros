GameOverScene = Core.class(Sprite)

--[[

	params = {
		score - score from last game round
		isSoundEnabled  - flag for sound managment
	}

--]]

function GameOverScene:init(params)
	
	if params ~= nil then
		if params.score ~= nil and type(params.score) == "number" and params.score > 0 then
			self.medal_gold = Bitmap.new(Texture.new("assets/images/medal_gold.png"))
			self.medal_silver = Bitmap.new(Texture.new("assets/images/medal_silver.png"))
			self.medal_platinum = Bitmap.new(Texture.new("assets/images/medal_platinum.png"))
			self.score = params.score
		else
			self.score = 0
		end
		
		if params.isSoundEnabled ~= nil then
			self.isSoundEnabled = params.isSoundEnabled
		else
			self.isSoundEnabled = true
		end
		
	else 
		self.score = 0
		self.isSoundEnabled = true
	end
	
	
	
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
		

	self.scoreboard = Bitmap.new(Texture.new("assets/images/scoreboard.png"))
	self.scoreboard:setAnchorPoint(0.5, 0.5)
	local scoreboard_scale = conf.SCOREBOARD_SCALE / self.scoreboard:getWidth()
	self.scoreboard:setScale(scoreboard_scale, scoreboard_scale)
	self.scoreboard:setPosition(conf.WIDTH / 2, conf.HEIGHT / 2)
	
	local bottom_buttons_pos_y = conf.HEIGHT / 2 + self.scoreboard:getHeight() / 3
	
	local replay = Bitmap.new(Texture.new("assets/images/replay.png"))
	replay:setAnchorPoint(0.5, 0.5)
	local replay_scale = conf.REPLAY_SCALE / replay:getWidth()
	replay:setScale(replay_scale, replay_scale)

	self.replay_button = Button.new(replay)
	self.replay_button:setPosition(conf.WIDTH / 2 - self.scoreboard:getWidth() / 2 + replay:getWidth() / 2, bottom_buttons_pos_y)
	
	self.replay_button:addEventListener("click", function() 
		sceneManager:changeScene("level", conf.TRANSITION_TIME,  SceneManager.fade, easing.inOutQuadratic, {
			userData = {
				isSoundEnabled = self.isSoundEnabled
			}
		})
	end)
	
	local score = Bitmap.new(Texture.new("assets/images/button_score.png"))
	score:setAnchorPoint(0.5, 0.5)
	local button_score_scale = conf.BUTTON_SCORE_SCALE / score:getWidth()
	score:setScale(button_score_scale, button_score_scale)
	
	self.score_button = Button.new(score)
	self.score_button:setPosition(conf.WIDTH / 2 + self.scoreboard:getWidth() / 2 - score:getWidth() / 2, bottom_buttons_pos_y)
	
	
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


	self:addChild(self.land)
	self:addChild(self.bg)
	self:addChild(self.scoreboard)
	self:addChild(self.replay_button)
	self:addChild(self.score_button)
	
	self:showScore(self.score)
	
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)

end

function GameOverScene:showScore(score)
	
	local score_imgs = {}
	score_imgs = self:getScoreImages(score)
	
	local number_scale = conf.GAME_OVER_NUMBER_SCALE / score_imgs[1]:getWidth()
	
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

function GameOverScene:onKeyDown(event)
	if event.keyCode == KeyCode.BACK then 
		if application:getDeviceInfo() == "Android" then
			sceneManager:changeScene("menu", conf.TRANSITION_TIME,  SceneManager.fade, easing.inOutQuadratic, {userData = {isSoundEnabled = self.isSoundEnabled}})
		end
	end
end