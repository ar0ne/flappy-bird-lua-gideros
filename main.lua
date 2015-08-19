local sceneManager = SceneManager.new({
	["level"] = level,
})

stage:addChild(sceneManager)

sceneManager:changeScene("level", 1, SceneManager.fade)
