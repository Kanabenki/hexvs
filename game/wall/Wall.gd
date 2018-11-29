extends KinematicBody2D

enum Position {LEFT, RIGHT, UP, DOWN}
onready var ext = $WallCollider.shape.extents

export(Position) var pos = Position.LEFT

func _physics_process(delta):
	var rect = GameManager.safe_rect
	match pos:
		Position.LEFT:
			position.x = rect.position.x - ext.x
		Position.RIGHT:
			position.x = rect.end.x + ext.x
		Position.UP:
			position.y = rect.position.y - ext.y
		Position.DOWN:
			position.y = rect.end.y + ext.y