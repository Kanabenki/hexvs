extends Node

var margin = 0.03
var base_safe_perc = 0.95
var safe_perc = base_safe_perc
var safe_rect = Rect2()
var tot_delta = 0
var _started = false

onready var music_player = AudioStreamPlayer.new()

var p1_points = 0
var p2_points = 0
var p1_charges = 3
var p2_charges = 3
var dead_player = 0

onready var screen_size = get_viewport().get_visible_rect().size

func _ready():
	var audio_file = "res://sound/music.ogg"
	var music = load(audio_file)
	music_player.bus = "Music"
	music_player.stream = music
	add_child(music_player)
	music_player.play()

func start_game():
	p1_charges = 3
	p2_charges = 3
	call_deferred("_deferred_start_game")

func _deferred_start_game():
	var root = get_tree().get_root()
	var curr_scene = root.get_child(root.get_child_count() - 1)
	curr_scene.free()
	
	var game_scene = ResourceLoader.load("res://game/Game.tscn")
	var new_scene = game_scene.instance()
	get_tree().get_root().add_child(new_scene)
	get_tree().set_current_scene(new_scene)
	
	_started = true


func _physics_process(delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()
	if _started:
		_tick(delta)

func _tick(delta):
	tot_delta += delta
	safe_perc = base_safe_perc - abs(sin(tot_delta*1.5)) * margin
	var unsafe_perc = 1.0 - safe_perc
	safe_rect = Rect2(Vector2(screen_size.x * unsafe_perc, screen_size.y * unsafe_perc), screen_size * (1 - unsafe_perc * 2))

func _on_Player_player_died(position, player_nb):
	if not _started:
		return
	dead_player = player_nb
	print("p1: " + str(p1_points) + " ||| p2: " + str(p2_points))
	if player_nb == 2:
		p1_points += 1
	else:
		p2_points += 1
	_started = false
	
func _on_Player_charges_changed(nb, pnb):
	if pnb == 1:
		p1_charges = nb
	else:
		p2_charges = nb
	
func _on_Camera_death_zoom_finished():
	start_game()