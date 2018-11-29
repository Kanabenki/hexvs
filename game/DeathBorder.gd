extends ColorRect

var safe_perc = 1.0

func _process(delta):
	safe_perc = GameManager.safe_perc
	material.set_shader_param("fill_perc", 1.0 - safe_perc)