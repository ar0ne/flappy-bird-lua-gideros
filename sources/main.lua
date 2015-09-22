require "box2d"

sceneManager = SceneManager.new({
	["level"] 		= LevelScene,
	["game_over"] 	= GameOverScene,
	["menu"] 		= MenuScene
})

stage:addChild(sceneManager)

sceneManager:changeScene("menu", conf.TRANSITION_TIME,  SceneManager.fade)
