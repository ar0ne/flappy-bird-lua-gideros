LevelScene = Core.class(Sprite)

--[[

    params = {
        isSoundEnabled 
        best_score
    }

--]]

function LevelScene:init(params)

    local util = Utils.new()
    
    if params ~= nil then
        if params.isSoundEnabled ~= nil and type(params.isSoundEnabled) == "boolean" then
            self.isSoundEnabled = params.isSoundEnabled
        else
            self.isSoundEnabled = true
        end 
        
        if params.best_score ~= nil then
            self.best_score = params.best_score
        else
            self.best_score = util:readBestScoreFromFile()
        end
        
    else
        self.isSoundEnabled = true
        self.best_score = util:readBestScoreFromFile()
    end

    self.world = b2.World.new(0, conf.GRAVITY, true)
    
    self.paused = true
    
    self.land = Land.new{
        level           = self,
        speed           = conf.LAND_SPEED,
        scale           = conf.LAND_SCALE,
        level_height    = conf.HEIGHT,
        level_width     = conf.WIDTH,
    }
    
    self.bg   = Background.new{
        level           = self,
        speed           = conf.BG_SPEED,
        level_height    = conf.HEIGHT,
        level_width     = conf.WIDTH,
        raw_scale       = conf.HEIGHT - self.land.land_height
    }
    
    self.bird = Bird.new{
        level           = self,
        pos_x           = conf.BIRD_POS_X,
        pos_y           = conf.HEIGHT / 2,
        level_height    = conf.HEIGHT,
        speed           = conf.BIRD_SPEED
    }
    self.bird:createBody()
    
    self.pipe = Pipe.new{
        level           = self,
        bottom_offset   = self.land.land_height,
        side_offset     = conf.PIPE_SIDE_OFFSET,
        speed           = conf.PIPE_SPEED,
        level_width     = conf.WIDTH,
        level_height    = conf.HEIGHT,
        pipe_offset     = conf.PIPE_OFFSET,
        pipe_scale      = conf.PIPE_SCALE,  
        pipe_end_scale  = conf.PIPE_END_SCALE,
        player_pos_x    = conf.BIRD_POS_X
    }

    
    self.score = Score.new{
        scale           = conf.SCORE_SCALE,
        level_width     = conf.WIDTH
    }
    
    self.splashscreen = Splashscreen.new{
        level           = self,
        pos_x           = conf.WIDTH / 2,
        pos_y           = conf.HEIGHT / 2,
        scale           = conf.SPLASHSCREEN_SCALE,
    }
    
    self.die_sound = Sound.new("assets/sounds/sfx_hit.mp3")
        
    
    self:addChild(self.bg)
    self:addChild(self.land)
    self:addChild(self.pipe)
    self:addChild(self.bird)
    self:addChild(self.score)
    self:addChild(self.splashscreen)
    
    ----- DEBUG ---------
    if conf.DEBUG_MODE then
        local debugDraw = b2.DebugDraw.new()
        self.world:setDebugDraw(debugDraw)
        self:addChild(debugDraw)
    end
    ---------------------
    
    self.bg.paused = false
    self.land.paused = false

    
    ------ EVENTS -------
    self:addEventListener("pipe_passed", self.onPipePassed, self)
    self.world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
    self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
    self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
    self:addEventListener("splashscreen_showed", self.onSplashScreenShowed, self)
    ---------------------
    
end

function LevelScene:onEnterFrame(event)

    if not self.paused then
        event:stopPropagation()
        
        self.world:step(1/60, 8, 3)
        local body = self.bird.body
        body.object:setPosition(body:getPosition())

    end
end

function LevelScene:onBeginContact(event)
    event:stopPropagation()
    
    if not self.paused and not self.bird.paused then
    
        local fixtureA = event.fixtureA
        local fixtureB = event.fixtureB
        local bodyA = fixtureA:getBody()
        local bodyB = fixtureB:getBody()
        
        if bodyA.type and bodyB.type then
            if ((bodyA.type == "player" and bodyB.type == "wall") or
                (bodyB.type == "player" and bodyA.type == "wall")) then
                self.pipe.paused = true
                self.land.paused = true
                self.bg.paused = true
                self.bird.paused = true
                
                if self.isSoundEnabled then
                    self.die_sound:play()
                end
                
                sceneManager:changeScene("game_over", conf.TRANSITION_TIME,  SceneManager.fade, easing.inOutQuadratic, {
                    userData = {
                        score           = self.score.count, 
                        isSoundEnabled  = self.isSoundEnabled,
                        best_score      = self.best_score,
                    }
                })
            end
        end
    end
end

function LevelScene:onPipePassed(event)
    -- Increment game score
    event:stopPropagation()
    self.score:updateScore(self.score.count + 1)
end

function LevelScene:onKeyDown(event)
    if event.keyCode == KeyCode.BACK then 
        if application:getDeviceInfo() == "Android" then
            sceneManager:changeScene("menu", conf.TRANSITION_TIME,  SceneManager.fade, easing.inOutQuadratic, {
                userData = {
                    isSoundEnabled = self.isSoundEnabled
                }
            })
        end
    end
end

function LevelScene:onSplashScreenShowed(event)
    event:stopPropagation()
    
    self.pipe.paused = false
    self.bird.paused = false
    self.splashscreen.showed = false
    self.paused = false
    self.bird.body:setLinearVelocity(0, -self.bird.speed)
end
