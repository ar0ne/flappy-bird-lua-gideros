start_level = Core.class(Sprite)

function start_level:init()

	local bird = Bird.new()
	bird:setPosition(50, 50)
	
	self:addChild(bird)
end