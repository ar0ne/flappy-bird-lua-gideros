local sceneManager = SceneManager.new({
	["level"] = level,
})

stage:addChild(sceneManager)

sceneManager:changeScene("level", conf.transitionTime,  SceneManager.fade)
