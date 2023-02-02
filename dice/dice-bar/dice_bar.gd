extends NinePatchRect

var selected_dice = [null, null, null] # Index of the dice in PlayerDiceBank.dice
var has_rolled_once = false
var selected_face_index = null

onready var _empty_icon = load("res://dice/die-empty-slot.png")
onready var _die_numbers = $DiceNumbers
onready var _die_faces = $DiceFaces
onready var _die_action_labels = $DiceFaceActions
onready var _die_anim_players = $DieAnimationPlayers

onready var _roll_btn = get_tree().current_scene.get_node("CanvasLayer/RollBtn")
onready var _dice_bank = get_tree().current_scene.get_node("CanvasLayer/DiceBank")
onready var _die_face_info = get_tree().current_scene.get_node("CanvasLayer/DieFaceInfo")
onready var _action_options = get_tree().current_scene.get_node("CanvasLayer/ActionOptions")

func _ready():
	_roll_btn.connect("pressed", self, "_on_roll_pressed")
	
	# Set on hover for die face
	var faces = _die_faces.get_children()
	for i in range(faces.size()):
		faces[i].connect("mouse_entered", self, "_on_face_entered", [i])
		faces[i].connect("mouse_exited", self, "_on_face_exited", [i])
		faces[i].connect("gui_input", self, "_on_face_pressed", [i])

func _on_face_pressed(event, i):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if selected_dice[i] == null:
				return
			
			if selected_face_index != null:
				if selected_face_index == i:
					deselect_face()
					return
				else:
					deselect_face()
			
			# Set selected face for action options
			var die_index = selected_dice[i]
			_action_options.selected_die_index = die_index
			
			# Set selected face node index and hide die face info
			selected_face_index = i
			_die_face_info.visible = false
			
			# Play selected face animation and show action options
			var pos = Vector2(_die_faces.get_child(i).get_global_position().x - (_action_options.rect_size.x / 2.5), _action_options.get_global_position().y)
			
			_die_faces.get_child(i).get_node("AnimationPlayer").play("selected")
			_action_options.set_global_position(pos)
			_action_options.visible = true

# Reset the die face and unassign selected face index
func deselect_face():
	var face_node = _die_faces.get_child(selected_face_index)
	
	var die_index = selected_dice[selected_face_index]
	var die = PlayerDiceBank.dice[die_index]
	
	# Update action label for die face if needed
	if die.action_set:
		_die_action_labels.get_child(selected_face_index).text = "SET"
	elif die.action_discard:
		_die_action_labels.get_child(selected_face_index).text = "DISCARD"
		
	face_node.get_node("AnimationPlayer").play("idle")
	
	selected_face_index = null
	_action_options.visible = false

# On die face mouse entered
func _on_face_entered(i):
	if selected_dice[i] == null:
		return
	
	# Move info box to position with the corresponding die info
	var die_index = selected_dice[i]
	var die = PlayerDiceBank.dice[die_index]
	
	var face_node = _die_faces.get_child(i)
	var y_offset = Vector2(0, (face_node.rect_size.y / 2) + 8)
	
	_die_face_info.set_face_info(die.curr_face)
	_die_face_info.set_global_position(face_node.rect_global_position - (face_node.rect_size / 6) - y_offset)
	
	_die_face_info.visible = true
	
	# Scale up face node
	face_node.rect_scale = Vector2(1.05, 1.05)

# On die face mouse exited
func _on_face_exited(i):
	if selected_dice[i] == null:
		return
	
	# Hide info box after exiting a die face node
	_die_face_info.visible = false
	
	# Scale down face node
	var face_node = _die_faces.get_child(i)
	face_node.rect_scale = Vector2(1, 1)

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
			_die_anim_players.get_child(i).play("roll")
			
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
