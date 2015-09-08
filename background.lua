Background = Core.class(Sprite)

--[[

	level
	speed
	level_height
	level_width
	raw_scale 
	
--]]
function Background:init(options)

	self.level 		= options.level
	self.bg_speed 	= options.speed
	self.level_width 	= options.level_width
	self.level_height 	= options.level_height
	self.paused 	= true
	
	-- this image need to edit
	self.background = {
		Bitmap.new(Texture.new("assets/images/sky.png")),
		Bitmap.new(Texture.new("assets/images/sky.png")),
	}
    	
    local bg_scale = options.raw_scale / self.background[1]:getHeight()
		
	for i = 1, #self.background do 
		self.background[i]:setScale(bg_scale, bg_scale)
		self.background[i]:setAnchorPoint(0.5, 0)
		self:addChild(self.background[i])
	end
	
	self.bg_width = self.background[1]:getWidth()
	
	self.background[1]:setPosition(0, 0)
	self.background[2]:setPosition(self.bg_width - 1, 0)
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end


function Background:onEnterFrame(event)

	if not self.paused then
		for i = 1, #self.background do
			self.background[i]:setPosition(self.background[i]:getX() - self.bg_speed , 0)
				
				
			print(self.background[i]:getX())	
			-- if some image hide from screen then replace it
			if self.background[i]:getX() + self.bg_width < 0  then
				self.background[i]:setX(self.bg_width - 1)
			end
		end
	end
	
end