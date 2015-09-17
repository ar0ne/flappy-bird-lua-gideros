Button = Core.class(Sprite)

function Button:init(sprite)

	self:addChild(sprite)
	
	--- EVENTS -----
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	
end

function Button:onMouseDown(event)
	
	if self:hitTestPoint(event.x, event.y) then
		-- click on button
		event:stopPropagation()
		local clickEvent = Event.new("click")
		self:dispatchEvent(clickEvent)
	end
end

function Button:onMouseUp(event)
	event:stopPropagation()	
end