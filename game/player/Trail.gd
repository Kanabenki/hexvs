extends Line2D

export(NodePath) var target_path
export var OFFSET = 40
export var MAX_POINTS = 10

onready var target = get_node(target_path)

func _process(delta):
	add_point(target.position + target.transform.y * OFFSET)
	while get_point_count() > MAX_POINTS:
		remove_point(0)
