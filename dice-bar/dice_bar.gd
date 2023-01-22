extends NinePatchRect

var selected_dice = [null, null, null]
var has_rolled_once = false

onready var _empty_icon = load("res://dice-bar/die-empty-slot.png")
onready var _die_numbers = $DiceNumbers

func _ready():
	# TEMPORARY - add and remove should be done on click from dice bank
	add_die(PlayerDiceBank.dice[2])

func add_die(die):
	var index = 0
	
	for i in range(selected_dice.size() - 1):
		if selected_dice[i] == null:
			index = i
			break
	
	selected_dice[index] = die
	_die_numbers.get_child(index).texture = die.number_icon
	
func remove_die(die):
	# TEMPORARY:
	# TODO: Find die and remove from array and also remove from the dice bar by setting to empty icon
	_die_numbers.get_child(0).texture = _empty_icon
