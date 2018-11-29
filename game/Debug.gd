extends Label
export var nb = 1
var path = "../Players/Player" + str(nb)
onready var player = get_node(path)

func _ready():
	print(path)

func _process(delta):
	text = "CHARGE: " + str(player.charge) + "\nSpeed: " + str(player.speed) + "\nDir: " + str(player.direction)