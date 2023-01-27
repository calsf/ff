extends NinePatchRect

var selected_dice = [null, null, null]
var has_rolled_once = false

onready var _empty_icon = load("res://dice/die-empty-slot.png")
onready var _die_numbers = $DiceNumbers

func _ready():
	pass

# Adds die to the dice bar, return true or false for success/fail
func add_die(i):
	var die = PlayerDiceBank.dice[i]
	
	# Return if die is already selected
	if die.is_selected:
		return false
	
	# Return if die is empty
	if die.is_empty:
		return false
	
	var index = -1
	
	# Get first empty slot
	for i in range(selected_dice.size()):
		if selected_dice[i] == null:
			index = i
			break
	
	# Return if no empty slots
	if index == -1:
		return false
	
	# Set slot
	selected_dice[index] = die
	_die_numbers.get_child(index).texture = die.number_icon
	die.is_selected = true
	
	return true

# Removes die from dice bar, return true or false for success/fail
func remove_die(i):
	var die = PlayerDiceBank.dice[i]
	
	var index = -1
	
	# Look for die to remove
	for i in range(selected_dice.size()):
		if selected_dice[i] == die:
			index = i
			break
	
	# Return if not found
	if index == -1:
		return false
	
	# Remove die if found
	selected_dice[index] = null
	_die_numbers.get_child(index).texture = _empty_icon
	die.is_selected = false
	
	return true
