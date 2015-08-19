level = Core.class(Sprite)

function level:init()

	local height = application:getContentHeight()
	local width =  application:getContentWidth()

    local bird = Bird.new()
    bird:setPosition(50, 50)
    
    local background = Bitmap.new(Texture.new("assets/images/sky.png"))
    
    local background_scale =  height / background:getHeight()
    background:setScale(background_scale, background_scale)

    tube = Tube.new()
	
    self:addChild(background)   
    self:addChild(bird)
end