extends NinePatchRect

var selected_dice = [null, null, null]
var has_rolled_once = false

onready var _empty_icon = load("res://dice/die-empty-slot.png")
onready var _die_numbers = $DiceNumbers

func _ready():
	pass

# Adds die to the dice bar
func add_die(die):
	var index = -1
	
	# Get first empty slot
	for i in range(selected_dice.size()):
		if selected_dice[i] == null:
			index = i
			break
	
	# Return if no empty slots
	if index == -1:
		return
	
	# Set slot
	selected_dice[index] = die
	_die_numbers.get_child(index).texture = die.number_icon

# Removes die from dice bar
func remove_die(die):
	var index = -1
	
	# Look for die to remove
	for i in range(selected_dice.size()):
		if selected_dice[i] == die:
			index = i
			break
	
	# Return if not found
	if index == -1:
		return
	
	# Remove die if found
	selected_dice[index] = null
	_die_numbers.get_child(index).texture = _empty_icon
