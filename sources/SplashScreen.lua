Splashscreen = Core.class(Sprite)

--[[

	pos_x
	pos_y
	scale

--]]

function Splashscreen:init(options)
	
	self.splash_image = Bitmap.new(Texture.new("assets/images/splash.png"))
	self.splash_image:setAnchorPoint(0.5, 0.5)
	self.splash_image:setPosition(options.pos_x, options.pos_y)
	self.splash_image:setScale(options.scale, options.scale)

	self:addChild(self.splash_image)
	self:addEventListener(Event.MOUSE_DOWN, self.hide, self)
	
	self.showed = false
	
end


function Splashscreen:hide()
	
	self:removeChild(self.splash_image)	
	self:removeEventListener(Event.MOUSE_DOWN, self.hide, self)
	self.showed = true
	
end

