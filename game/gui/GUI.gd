extends Control

export(Texture) var p1_charge_empty = preload("res://game/gui/player1-charge-empty.png")
export(Texture) var p1_charge_full = preload("res://game/gui/player1-charge-full.png")
export(Texture) var p2_charge_empty = preload("res://game/gui/player2-charge-empty.png")
export(Texture) var p2_charge_full = preload("res://game/gui/player2-charge-full.png")

onready var p1_score = $Player1Box/Score
onready var p2_score = $Player2Box/Score

onready var p1_charges_list = [$Player1Box/Charge3, $Player1Box/Charge2, $Player1Box/Charge1]
onready var p2_charges_list = [$Player2Box/Charge3, $Player2Box/Charge2, $Player2Box/Charge1]

func _ready():
	update_score()
	update_charges()

func _process(delta):
	update_charges()

func update_score():
	var p1 = GameManager.p1_points
	var p2 = GameManager.p2_points
	p1_score.text = str(p1)
	p2_score.text = str(p2)
	
func update_charges():
	for i in range(0, 3):
		var p1_charges = GameManager.p1_charges
		var p2_charges = GameManager.p2_charges
		if p1_charges > i:
			p1_charges_list[i].texture = p1_charge_full
		else:
			p1_charges_list[i].texture = p1_charge_empty 
			
		if p2_charges > i:
			p2_charges_list[i].texture = p2_charge_full
		else:
			p2_charges_list[i].texture = p2_charge_empty 
			
		
		