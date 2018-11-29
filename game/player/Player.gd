extends KinematicBody2D

signal player_died(position, player_nb)
signal charges_changed(nb, player_nb)
signal explosion_finished()

export var MOVE_SPEED = 700.0
export var DASH_SPEED = 1600.0
export var DASH_LENGTH = 0.20
export var CHARGE_LENGTH = 0.7
export var MAX_CHARGE = 3

export(PackedScene) var SHIELD_SCENE = preload("res://game/player/shield/Shield.tscn")

export var pnumber = 1

var speed = Vector2()
var charge = MAX_CHARGE
var direction = Vector2()

onready var dash_timer = $DashTimer
onready var charge_timer = $ChargeTimer
onready var animation_player = $AnimationPlayer

onready var dash_sound_player = $DashSoundPlayer

enum State {NORMAL, SHIELDING, DASHING}
var state = State.NORMAL

var bump = Vector2()
var round_over = false

func _ready():
	dash_timer.wait_time = DASH_LENGTH
	charge_timer.wait_time = CHARGE_LENGTH
	print(pnumber)
	
	connect("player_died", GameManager, "_on_Player_player_died")
	connect("charges_changed", GameManager, "_on_Player_charges_changed")
	connect("explosion_finished", GameManager, "_on_Player_explosion_finished")


func _physics_process(delta):
	if not round_over:
		direction = Vector2(
			Input.get_action_strength("right" + str(pnumber)) - Input.get_action_strength("left" + str(pnumber)),
			Input.get_action_strength("down" + str(pnumber)) - Input.get_action_strength("up" + str(pnumber))
			).normalized()
	else:
		direction = Vector2.ZERO
			
	match state:
		State.NORMAL:
			if not round_over and Input.is_action_just_pressed("dash" + str(pnumber)) and charge > 0:
					_do_dash()
			elif not round_over and Input.is_action_just_pressed("shield" + str(pnumber)) and charge > 0:
					_spawn_shield()
					_move()
			else:
				_move()
		State.SHIELDING:
			_move()
		State.DASHING:
			pass
	
	if bump.length() > 100:
		speed = bump
		bump /= 4
	var slide = move_and_slide(speed)
	var coll = get_slide_collision(0) if get_slide_count() > 0 else null
	
	if coll:
		var collider = coll.collider
		if collider.is_in_group("player") and state == State.DASHING:
			if collider.state == State.DASHING:
				bump = -transform.x * DASH_SPEED * 1
			else:
				collider.die()
				dash_sound_player.stop()
				round_over = true
		elif ((collider.is_in_group("player") and state != State.DASHING and collider.state == State.DASHING)
					or collider.is_in_group("wall")
					or (collider.is_in_group("shield") and state == State.DASHING)):
			dash_sound_player.stop()
			round_over = true
			emit_signal("player_died", position, pnumber)

func _move():
	speed = direction * MOVE_SPEED
	look_at(position + direction)	

func die():
	round_over = true
	emit_signal("player_died", position, pnumber)

func _do_dash():
	state = State.DASHING
	randomize()
	dash_sound_player.pitch_scale = randf() * 0.2 + 0.8
	dash_sound_player.play()
	dash_timer.start()
	speed = transform.x * DASH_SPEED
	_dec_charge()
	
func play_explosion():
	animation_player.play("explosion")
		

func _spawn_shield():
	state = State.SHIELDING
	
	var shield = SHIELD_SCENE.instance()
	var offset = transform.x * 100
	shield.position = position + offset
	shield.rotation = rotation
	
	shield.link(self, offset)
	get_parent().add_child(shield)
	_dec_charge()
	
func _dec_charge():
	charge -= 1
	emit_signal("charges_changed", charge, pnumber)
	charge_timer.start()
	
func on_Shield_shield_over():
	if state == State.SHIELDING:
		state = State.NORMAL

func _on_DashTimer_timeout():
	if state == State.DASHING:
		state = State.NORMAL

func _on_ChargeTimer_timeout():
	if charge < MAX_CHARGE:
		charge += 1
		emit_signal("charges_changed", charge, pnumber)

