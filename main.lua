require "box2d"

sceneManager = SceneManager.new({
	["level"] = LevelScene,
})

stage:addChild(sceneManager)

sceneManager:changeScene("level", conf.TRANSITION_TIME,  SceneManager.fade)
