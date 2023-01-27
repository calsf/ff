extends NinePatchRect

var selected_dice = [null, null, null] # Index of the dice in PlayerDiceBank.dice
var has_rolled_once = false

onready var _empty_icon = load("res://dice/die-empty-slot.png")
onready var _die_numbers = $DiceNumbers
onready var _die_faces = $DiceFaces
onready var _die_anim_players = $DieAnimationPlayers

onready var _roll_btn = get_tree().current_scene.get_node("CanvasLayer/RollBtn")
onready var _dice_bank = get_tree().current_scene.get_node("CanvasLayer/DiceBank")

func _ready():
	_roll_btn.connect("pressed", self, "_on_roll_pressed")

# Rolls all selected dice
func _on_roll_pressed():
	# Prevent rolling more than once
	if has_rolled_once:
		return
	
	for i in range(selected_dice.size()):
		if selected_dice[i] != null:
			var die_index = selected_dice[i]
			var die = PlayerDiceBank.dice[die_index]
			
			# Show used overlay on rolled die
			_dice_bank.die_used_overlay(selected_dice[i], true)
			
			# Play anim
			_die_anim_players.get_children()[i].play("roll")
			
			# Randomize face
			randomize()
			die.curr_face = die.faces[randi() % die.faces.size()]
			
			# Update face icon
			var face_node = _die_faces.get_child(i)
			face_node.texture = die.curr_face.icon
			
			# Update face num value
			var num_value = die.curr_face.num_value
			var num_value_label = face_node.get_node("NumValue")
		
			if num_value == null or num_value == 0:
				num_value_label.text = ""
			else:
				num_value_label.text = str(num_value)
			
			has_rolled_once = true

# Adds die to the dice bar, return true or false for success/fail
func add_die(i):
	# Dice bank should be disabled after first roll
	if has_rolled_once:
		return
	
	var die = PlayerDiceBank.dice[i]
	
	# Return if die is already selected or used
	if die.is_selected or die.is_used:
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
	selected_dice[index] = i
	_die_numbers.get_child(index).texture = die.number_icon
	
	return true

# Removes die from dice bar, return true or false for success/fail
func remove_die(i):
	# Dice bank should be disabled after first roll
	if has_rolled_once:
		return
	
	var die = PlayerDiceBank.dice[i]
	
	# Return if die is not selected or is used
	if not die.is_selected or die.is_used:
		return false
	
	# Return if die is empty
	if die.is_empty:
		return false
	
	var index = -1
	
	# Look for die to remove
	for selected_i in range(selected_dice.size()):
		var die_index = selected_dice[selected_i]
		
		if die_index and PlayerDiceBank.dice[die_index] == die:
			index = selected_i
			break
	
	# Return if not found
	if index == -1:
		return false
	
	# Remove die if found
	selected_dice[index] = null
	_die_numbers.get_child(index).texture = _empty_icon
	
	return true
