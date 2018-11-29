extends KinematicBody2D

signal shield_over
var parent
var offset

func link(parent, offset):
	connect("shield_over", parent, "on_Shield_shield_over")
	self.parent = parent
	self.offset = offset

func _physics_process(delta):
	position = parent.position + offset

func _on_Timer_timeout():
	emit_signal("shield_over")
	get_parent().remove_child(self)
