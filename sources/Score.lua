Score = Core.class(Sprite)

--[[

	scale
	level_width

--]]
function Score:init(options)

	self.scale = options.scale
	self.level_width = options.level_width

	self.numbers = {
		Texture.new("assets/images/fonts/big/font_big_0.png"),
		Texture.new("assets/images/fonts/big/font_big_1.png"),
		Texture.new("assets/images/fonts/big/font_big_2.png"),
		Texture.new("assets/images/fonts/big/font_big_3.png"),
		Texture.new("assets/images/fonts/big/font_big_4.png"),
		Texture.new("assets/images/fonts/big/font_big_5.png"),
		Texture.new("assets/images/fonts/big/font_big_6.png"),
		Texture.new("assets/images/fonts/big/font_big_7.png"),
		Texture.new("assets/images/fonts/big/font_big_8.png"),
		Texture.new("assets/images/fonts/big/font_big_9.png"),
	}
	
	self.count = 0
	self.imgs = {}
	
	self:updateScore(self.count)
	
end

function Score:getScoreImages(num)
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


function Score:setNewScore(new_score)

	if new_score == self.count and new_score ~= 0 then
		return false
	end
	
	self.count = new_score
	
	return true
end

function Score:updateScore(new_score)

	if self:setNewScore(new_score) then
	
		for i = 1, #self.imgs do
			self:removeChild(self.imgs[i])
		end
		
		self.imgs = {}
		self.imgs = self:getScoreImages(new_score)
		
		local image_width = self.numbers[1]:getWidth()
		local scale = self.scale / image_width
		
		for i = 1, #self.imgs do
		
			local num = self.imgs[i]
			
			num:setScale(scale, scale)
			num:setAnchorPoint(0.5, 0.5)
			
			if #self.imgs == 1 then
				self.imgs[i]:setPosition(self.level_width / 2, 100)
			elseif #self.imgs == 2 then
				self.imgs[i]:setPosition(self.level_width / 2 + math.pow((-1), i) * image_width, 100)
			elseif #self.imgs == 3 then
				self.imgs[i]:setPosition(self.level_width / 2 + (i - 2) * image_width, 100)
			end
			
			self:addChild(num)
		end
	end

end