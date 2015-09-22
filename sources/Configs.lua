
local W = application:getDeviceWidth()
local H = application:getDeviceHeight()

conf = {

	-- TRANSITION = SceneManager.fade,

	HEIGHT 				= H,
	WIDTH 				= W,
	TRANSITION_TIME 	= 1,
	
	BG_SPEED 			= 1.2,
	PIPE_SPEED 			= 4.4,
	BIRD_SPEED 			= 0.1  * H,
	GRAVITY 			= 0.075 * H,
	LAND_SPEED 			= 4.4,
	
	PIPE_OFFSET 		= 0.17 * H,
	
	PIPE_SCALE 			= 0.15 * W,
	PIPE_END_SCALE 		= 0.16 * W,
	PIPE_SIDE_OFFSET 	= 0.7  * W,
	
	BIRD_SCALE 			= 0.12 * W,
	
	BIRD_POS_X 			= W / 3,
	
	LAND_SCALE 			= 0.2  * H,
	SCORE_SCALE 		= 0.07 * W,
	
	SPLASHSCREEN_SCALE 	= 0.7 * W,
	
	SCOREBOARD_SCALE 	= 0.8 * W,
	REPLAY_SCALE 		= 0.35 * W,
	
	GAME_OVER_NUMBER_SCALE = 0.035 * H,
	
	LOGO_SCALE 			= 0.8  * W,
	BUTTON_RATE_SCALE 	= 0.18 * W,
	BUTTON_SCORE_SCALE 	= 0.35  * W,
	SOUND_ON_OFF_SCALE 	= 0.15 * W,

	MEDAL_SCALE 		= 0.19  * W,
	
	ANDROID_PACKAGE_NAME = "org.arone.flappy_bird",

}