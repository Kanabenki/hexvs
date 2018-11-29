extends ColorRect

func _on_HoverLabel_mouse_entered():
	get_child(0).visible = true


func _on_HoverLabel_mouse_exited():
	get_child(0).visible = false
