extends NinePatchRect

var selected_dice = [null, null, null] # Index of the dice in PlayerDiceBank.dice
var has_rolled_once = false
var has_played = false
var selected_face_index = null

var is_rerolling = false

onready var _empty_icon = load("res://dice/die-empty-slot.png")
onready var _die_numbers = $DiceNumbers
onready var _die_faces = $DiceFaces
onready var _die_action_labels = $DiceFaceActions
onready var _die_anim_players = $DieAnimationPlayers

onready var _roll_btn = get_tree().current_scene.get_node("CanvasLayer/RollBtn")
onready var _play_btn = get_tree().current_scene.get_node("CanvasLayer/PlayBtn")
onready var _reroll_btn = get_tree().current_scene.get_node("CanvasLayer/RerollBtn")
onready var _dice_bank = get_tree().current_scene.get_node("CanvasLayer/DiceBank")
onready var _die_face_info = get_tree().current_scene.get_node("CanvasLayer/DieFaceInfo")
onready var _action_options = get_tree().current_scene.get_node("CanvasLayer/ActionOptions")
onready var _reroll_action_btn = get_tree().current_scene.get_node("CanvasLayer/ActionOptions/HBoxContainer/ButtonReroll")

onready var _combat = get_tree().current_scene.get_node("CanvasLayer/Combat")

func _ready():
	_roll_btn.connect("pressed", self, "_on_roll_pressed")
	_play_btn.connect("pressed", self, "_on_play_pressed")
	_reroll_btn.connect("pressed", self, "_on_reroll_pressed")
	
	# Set on hover for die face
	var faces = _die_faces.get_children()
	for i in range(faces.size()):
		faces[i].connect("mouse_entered", self, "_on_face_entered", [i])
		faces[i].connect("mouse_exited", self, "_on_face_exited", [i])
		faces[i].connect("gui_input", self, "_on_face_pressed", [i])
	
	_check_can_roll()
	check_can_play()
	reset_dice_bar()

# Reset dice bar
func reset_dice_bar():
	for i in range(selected_dice.size()):
		if selected_dice[i] != null:
			var die_index = selected_dice[i]
			var die = PlayerDiceBank.dice[die_index]
			
			die.reset_die()
			
			var anim = _die_anim_players.get_child(i)
			anim.play("idle")
	
	for i in range(_die_action_labels.get_children().size()):
		_die_action_labels.get_child(i).text = "NO ACTION"
	
	selected_dice = [null, null, null]
	has_rolled_once = false
	has_played = false
	selected_face_index = null
	
	set_can_reroll(false)
	
	# Reset dice bank if all dice has been used
	if _dice_bank.all_dice_used():
		_dice_bank.reset_dice_bank()

# Select die faces
func _on_face_pressed(event, i):
	if is_rerolling:
		return
	
	if has_played:
		return
	
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
			
			_die_faces.get_child(i).play_anim("selected")
			_action_options.set_global_position(pos)
			_action_options.visible = true
			
			check_can_reroll_selected()

# Reset the die face and unassign selected face index
func deselect_face():
	if selected_face_index == null:
		return
	
	var face_node = _die_faces.get_child(selected_face_index)
	
	var die_index = selected_dice[selected_face_index]
	var die = PlayerDiceBank.dice[die_index]
	
	# Update action label for die face if needed
	if die.action_set:
		var action = "SET"
		
		# Append enemy number identifier if face has a target
		if die.target != null:
			action += " FACE " + str(die.target.enemy_num)
		
		_die_action_labels.get_child(selected_face_index).text = action
	elif die.action_discard:
		_die_action_labels.get_child(selected_face_index).text = "DISCARD"
		
	face_node.play_anim("idle")
	
	selected_face_index = null
	_action_options.visible = false

# On die face mouse entered
func _on_face_entered(i):
	if selected_dice[i] == null:
		return
	
	if has_played:
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
	
	var anim_to_wait_for = null
	for i in range(selected_dice.size()):
		if selected_dice[i] != null:
			var die_index = selected_dice[i]
			var die = PlayerDiceBank.dice[die_index]
			
			# Show used overlay on rolled die
			_dice_bank.die_used_overlay(selected_dice[i], true)
			
			# Deselect die
			die.is_selected = false
			
			# Play anim
			_die_anim_players.get_child(i).play("roll")
			
			# Set anim to yield for
			anim_to_wait_for = _die_anim_players.get_child(i)
			
			# Randomize face
			randomize()
			die.curr_face = die.faces[randi() % die.faces.size()]
			
			# Update face icon and num value
			var face_node = _die_faces.get_child(i)
			var num_value = die.curr_face.num_value
			face_node.set_face(die.curr_face.icon, num_value)
			
	has_rolled_once = true
	_check_can_roll()
	
	yield(anim_to_wait_for, "animation_finished")
	set_can_reroll(true)

# Plays all dice face
func _on_play_pressed():
	# Do not play if has not rolled yet or has already played
	if not has_rolled_once or has_played:
		return
	
	# Do not play until an action has been selected for all rolled dice
	if not _all_actions_selected():
		return
	
	# Only allow play once per turn
	has_played = true
	check_can_play()
	set_can_reroll(false)
	
	# Play each die face action
	for i in range(selected_dice.size()):
		if selected_dice[i] != null:
			var die_index = selected_dice[i]
			var die = PlayerDiceBank.dice[die_index]
			
			if die.action_set:
				_die_faces.get_child(i).play_anim("play")
				
				var anim = _die_anim_players.get_child(i)
				anim.play("play")
				yield(anim, "animation_finished")
				
				die.on_play(_combat)
			elif die.action_discard:
				_die_faces.get_child(i).play_anim("discard")
				
				var anim = _die_anim_players.get_child(i)
				anim.play("play")
				yield(anim, "animation_finished")
				
				die.on_discard(_combat)
	
	# Player turn has finished
	_combat.player_turn_finished()

# Reroll all dice
func _on_reroll_pressed():
	# Do not reroll if has not rolled yet or has already played
	if not has_rolled_once or has_played:
		return
	
	# Only reroll if have enough favor
	if _combat.favor < 1:
		return
	
	# Take favor
	_combat.add_favor(-1)
	
	# Disable reroll until anim is complete
	set_can_reroll(false)
	
	# Reset dice bar as needed
	for i in range(selected_dice.size()):
		if selected_dice[i] != null:
			var die_index = selected_dice[i]
			var die = PlayerDiceBank.dice[die_index]
			
			die.reset_die()
			
			var anim = _die_anim_players.get_child(i)
			anim.play("idle")
	
	for i in range(_die_action_labels.get_children().size()):
		_die_action_labels.get_child(i).text = "NO ACTION"
	
	if selected_face_index != null:
		deselect_face()
	check_can_play()
	
	# Reroll
	var anim_to_wait_for = null
	for i in range(selected_dice.size()):
		if selected_dice[i] != null:
			var die_index = selected_dice[i]
			var die = PlayerDiceBank.dice[die_index]
			
			# Show used overlay on rolled die
			_dice_bank.die_used_overlay(selected_dice[i], true)
			
			# Play anim
			_die_anim_players.get_child(i).play("roll")
			
			# Set anim to yield for
			anim_to_wait_for = _die_anim_players.get_child(i)
			
			# Randomize face
			randomize()
			die.curr_face = die.faces[randi() % die.faces.size()]
			
			# Update face icon and num value
			var face_node = _die_faces.get_child(i)
			var num_value = die.curr_face.num_value
			face_node.set_face(die.curr_face.icon, num_value)
	
	yield(anim_to_wait_for, "animation_finished")
	set_can_reroll(true)

# Reroll current selected die
func reroll_selected_die():
	# Do not reroll if has not rolled yet or has already played
	if not has_rolled_once or has_played:
		return
	
	# Only reroll if have enough favor
	if _combat.favor < 2:
		return
	
	# Must have a face selected to reroll
	if selected_face_index == null:
		return
	
	var i = selected_face_index
	
	# Take favor
	_combat.add_favor(-2)
	
	# Disable reroll until anim is complete
	set_can_reroll(false)
	
	is_rerolling = true
	
	# Reset dice bar as needed
	if selected_dice[i] != null:
		var die_index = selected_dice[i]
		var die = PlayerDiceBank.dice[die_index]
		
		die.reset_die()
		
		var anim = _die_anim_players.get_child(i)
		anim.play("idle")
	
	_die_action_labels.get_child(i).text = "NO ACTION"
	
	if selected_face_index != null:
		deselect_face()
	check_can_play()
	
	# Reroll
	var anim_to_wait_for = null
	if selected_dice[i] != null:
		var die_index = selected_dice[i]
		var die = PlayerDiceBank.dice[die_index]
		
		# Show used overlay on rolled die
		_dice_bank.die_used_overlay(selected_dice[i], true)
		
		# Play anim
		_die_anim_players.get_child(i).play("roll")
		
		# Set anim to yield for
		anim_to_wait_for = _die_anim_players.get_child(i)
		
		# Randomize face
		randomize()
		die.curr_face = die.faces[randi() % die.faces.size()]
		
		# Update face icon and num value
		var face_node = _die_faces.get_child(i)
		var num_value = die.curr_face.num_value
		face_node.set_face(die.curr_face.icon, num_value)
	
	yield(anim_to_wait_for, "animation_finished")
	set_can_reroll(true)
	is_rerolling = false

# Adds or removes die to the dice bar, return true or false for success/fail
func add_or_remove_die(i):
	# Dice bank should be disabled after first roll
	if has_rolled_once:
		return false
	
	var die = PlayerDiceBank.dice[i]
	
	# Return if die is already used
	if die.is_used:
		return false
	
	# Return if die is empty
	if die.is_empty:
		return false
	
	# If selected already, attempt to remove die
	if die.is_selected:
		_check_can_roll()
		return remove_die(i)
	
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
	
	die.is_selected = true
	
	_check_can_roll()
	return true

# Removes die from dice bar, return true or false for success/fail
func remove_die(i):
	# Dice bank should be disabled after first roll
	if has_rolled_once:
		return false
	
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
		
		if die_index != null and PlayerDiceBank.dice[die_index] == die:
			index = selected_i
			break
	
	# Return if not found
	if index == -1:
		return false
	
	# Remove die if found
	selected_dice[index] = null
	_die_numbers.get_child(index).texture = _empty_icon
	
	die.is_selected = false
	
	return true

# Check if roll btn should be disabled or not
func _check_can_roll():
	var die_selected = false
	for dice in selected_dice:
		if dice != null:
			die_selected = true
	
	if not die_selected or has_rolled_once:
		_roll_btn.disabled = true
		_roll_btn.set_modulate(Color(.7, .7, .7, 1))
	else:
		_roll_btn.disabled = false
		_roll_btn.set_modulate(Color(1, 1, 1, 1))

# Check if play btn should be disabled or not
func check_can_play():
	var actions_selected = _all_actions_selected()
	
	if not has_rolled_once or not actions_selected or has_played:
		_play_btn.disabled = true
		_play_btn.set_modulate(Color(.7, .7, .7, 1))
	else:
		_play_btn.disabled = false
		_play_btn.set_modulate(Color(1, 1, 1, 1))

# Check if reroll action option should be disabled or not
func check_can_reroll_selected():
	if _combat.favor < 2:
		_reroll_action_btn.disabled = true
		_reroll_action_btn.set_modulate(Color(.7, .7, .7, 1))
	else:
		_reroll_action_btn.disabled = false
		_reroll_action_btn.set_modulate(Color(1, 1, 1, 1))

# Disable or enable reroll btn, always disable if no favor
func set_can_reroll(enabled):
	if not enabled or _combat.favor <= 0:
		_reroll_btn.disabled = true
		_reroll_btn.set_modulate(Color(.7, .7, .7, 1))
	else:
		_reroll_btn.disabled = false
		_reroll_btn.set_modulate(Color(1, 1, 1, 1))

# Checks if an action has been seelected for all rolled dice
func _all_actions_selected():
	for i in range(selected_dice.size()):
		if selected_dice[i] != null:
			var die_index = selected_dice[i]
			var die = PlayerDiceBank.dice[die_index]
			
			if not die.action_set and not die.action_discard:
				return false
	
	return true
