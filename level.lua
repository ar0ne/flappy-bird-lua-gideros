level = Core.class(Sprite)

function level:init()

    local bird = Bird.new()
    bird:setPosition(conf.WIDTH * 0.3 , conf.HEIGHT / 2)
    
    local bg = Background.new()

    tube = Tube.new()
	
    self:addChild(bg)   
    self:addChild(bird)
end