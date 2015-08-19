local sceneManager = SceneManager.new({
	["start_level"] = start_level,
})

stage:addChild(sceneManager)

sceneManager:changeScene("start_level", 1, SceneManager.flipWithFade)
