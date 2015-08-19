Bird = Core.class(Sprite)

function Bird:init()
	self:addEventListener(Event.ADDED_TO_STAGE, self.onAddedToStage, self)
	self:addEventListener(Event.REMOVED_FROM_STAGE, self.onRemovedFromStage, self)
	
	local spritesheet = Texture.new("assets/images/bird.png")
	
	self.anim = {
		Bitmap.new(TextureRegion.new(spritesheet, 0,  0, 34, 24)),
		Bitmap.new(TextureRegion.new(spritesheet, 0, 24, 34, 24)),
		Bitmap.new(TextureRegion.new(spritesheet, 0, 48, 34, 24)),
		Bitmap.new(TextureRegion.new(spritesheet, 0, 72, 34, 24)),
	}
	
	self.frame = 1
	self:addChild(self.anim[1])
	
	self.nframes = #self.anim

	self.subframe = 0
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
end

function Bird:onAddedToStage(event)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Bird:onRemovedFromStage(event)
	self.removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Bird:onEnterFrame(event)
	-- bird animation
	self.subframe = self.subframe + 1

	if self.subframe > 4 then
		self:removeChild(self.anim[self.frame])
		
		self.frame = self.frame + 1
		if self.frame > self.nframes then
			self.frame = 1
		end

		self:addChild(self.anim[self.frame])
		
		self.subframe = 0
	end
end

function Bird:jump()
	
end


