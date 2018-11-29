extends Camera2D

export var ZOOM_MAX = 0.4
export var TRANS_DUR = 0.5
export var ZOOM_DUR = 0.4
var zoom_max_vec = Vector2(ZOOM_MAX, ZOOM_MAX)
var _died = false

export(NodePath) var p1_path
export(NodePath) var p2_path
var dead_player = 0

signal death_translation_finished()
signal death_zoom_finished()

onready var zoom_tween = $ZoomTween
onready var position_tween = $PositionTween
onready var zoom_sound_player = $ZoomSoundPlayer

func _ready():
	connect("death_zoom_finished", GameManager, "_on_Camera_death_zoom_finished")
	
func _on_Player_player_died(player_pos, player_nb):
	if _died:
		return
	_died = true
	
	dead_player = player_nb
	
	zoom_sound_player.play()
	zoom_tween.interpolate_property(self, "zoom", zoom, zoom_max_vec, ZOOM_DUR, Tween.TRANS_EXPO, Tween.EASE_OUT, TRANS_DUR)
	position_tween.interpolate_property(self, "position", position, player_pos, TRANS_DUR, Tween.TRANS_EXPO, Tween.EASE_OUT)
	position_tween.start()
	zoom_tween.start()
	

func _on_ZoomTween_tween_completed(object, key):
	print("restart")
	emit_signal("death_zoom_finished")


func _on_PositionTween_tween_completed(object, key):
	if dead_player == 1:
		get_node(p1_path).play_explosion()
	else:
		get_node(p2_path).play_explosion()
