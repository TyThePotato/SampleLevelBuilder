extends Label

func _process(delta):
	var fps = round(1.0 / delta)
	text = str(fps) + " FPS"
