Background = Core.class(Sprite)

function Background:init()
	
	self.bg_speed = conf.BG_SPEED
	
	-- this image need to edit
	self.background = {
		Bitmap.new(Texture.new("assets/images/sky.png")),
		Bitmap.new(Texture.new("assets/images/sky.png")),
	}
    	
    local bg_scale = conf.HEIGHT / self.background[1]:getHeight()
	
	self.bg_width = self.background[1]:getWidth()
		
	for i = 1, #self.background do 
		self.background[i]:setScale(bg_scale, bg_scale)
		self:addChild(self.background[i])
		self.background[1]:setPosition((i - 1) * self.bg_width, 0)
	end
	
	self:addEventListener(Event.ADDED_TO_STAGE, self.onAddedToStage, self)
	self:addEventListener(Event.REMOVED_FROM_STAGE, self.onRemovedFromStage, self)
end

function Background:onAddedToStage(event)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Background:onRemovedFromStage(event)
	self.removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Background:onEnterFrame(event)
	
	for i = 1, #self.background do
		self.background[i]:setPosition(self.background[i]:getX() - self.bg_speed , 0)
			
		-- print(i .. ':' .. self.background[i]:getX() + self.bg_width)
		-- if some image hide from screen then replace it
		if self.background[i]:getX() + self.bg_width <= 0  then
			self.background[i]:setX(self.bg_width )
		end
	end
	
end