extends NinePatchRect

export var die_face_info_path : String

onready var _dice_col = $HBoxDice
onready var _dice_col_selected = $HBoxDiceSelectedOverlay
onready var _dice_col_used = $HBoxDiceUsedOverlay

onready var _die_face_info = get_tree().get_root().get_node(die_face_info_path)

func _ready():
	PlayerDiceBank.connect("die_bank_updated", self, "update_dice_index")
	
	# Set up on click/hover events for each die in the dice bank
	var dice = get_dice_nodes()

	for i in range(dice.size()):
		dice[i].connect("mouse_entered", self, "_on_die_entered", [i])
		dice[i].connect("mouse_exited", self, "_on_die_exited", [i])
	
	# Hide selected die overlay
	for row in _dice_col_selected.get_children():
		for die in row.get_children():
			die.set_modulate(Color(1, 1, 1, 0))
	
	# Hide used die overlay
	for row in _dice_col_used.get_children():
		for die in row.get_children():
			die.set_modulate(Color(1, 1, 1, 0))
	
	# NEED TO MAKE SURE PLAYERDICEBANK.DICE HAS BEEN INITIALIZED BEFORE THIS
	# Initialize all the dice UI elements
	for i in range(PlayerDiceBank.dice.size()):
		update_dice_index(i)

func get_dice_nodes():
	var dice = []
	
	for col in range(_dice_col.get_children().size()):
		for row in range(_dice_col.get_child(col).get_children().size()):
			dice.append(_dice_col.get_child(col).get_child(row))
	
	return dice

# Disconnect all signals from dice in dice bank
func disconnect_dice_bank():
	var dice = get_dice_nodes()
	
	for i in range(dice.size()):
		if dice[i].is_connected("gui_input", self, "_on_die_pressed"):
			dice[i].disconnect("gui_input", self, "_on_die_pressed")
		dice[i].disconnect("mouse_entered", self, "_on_die_entered")
		dice[i].disconnect("mouse_exited", self, "_on_die_exited")
		
		_on_die_exited(i)
	
	_on_face_exited()

# Connects mouse entered/die entered and exited for all dice in dice bank
func connect_dice_entered_exited():
	var dice = get_dice_nodes()

	for i in range(dice.size()):
		dice[i].connect("mouse_entered", self, "_on_die_entered", [i])
		dice[i].connect("mouse_exited", self, "_on_die_exited", [i])

# Connects mouse enter/exit signals for face selection
func connect_face_entered_exited():
	var dice = get_dice_nodes()
	for die_index in range(dice.size()):
		var faces = dice[die_index].get_children()
		for face_index in range(1, faces.size()):
			faces[face_index].connect("mouse_entered", self, "_on_only_face_entered", [faces[face_index], PlayerDiceBank.dice[die_index].faces[face_index - 1]])
			faces[face_index].connect("mouse_exited", self, "_on_only_face_exited", [faces[face_index]])

# Disconnects mouse enter/exit signals for face selection	
func disconnect_face_entered_exited():
	var dice = get_dice_nodes()
	for die_index in range(dice.size()):
		var faces = dice[die_index].get_children()
		for face_index in range(1, faces.size()):
			faces[face_index].disconnect("mouse_entered", self, "_on_only_face_entered")
			faces[face_index].disconnect("mouse_exited", self, "_on_only_face_exited")
			_on_only_face_exited(faces[face_index])

# Reset all dice in dice bank
func reset_dice_bank():
	for i in range(PlayerDiceBank.dice.size()):
		_die_selected_overlay(i)
		die_used_overlay(i, false)

# Check if all dice in dice bank has been used or not
func all_dice_used():
	# If any die has not been used and is not an empty die, return false
	for i in range(PlayerDiceBank.dice.size()):
		if not PlayerDiceBank.dice[i].is_used and not PlayerDiceBank.dice[i].is_empty:
			return false
	
	return true

# In the children of the given root_node, get node for die of given i index
# Defaults to _dice_col but can get _dice_col_selected and _die_col_used
func _get_die_node(i, root_node = _dice_col):
	# Max index, can only be 12 dice
	if (i > 11):
		return null
	
	var col = i / 3
	var row = ( (i - (col * 3)) * 3) / 3
	
	var die = root_node.get_child(col).get_child(row)
	
	return die

# Get die faces for die of given i index
func _get_die_node_faces(i):
	var die = _get_die_node(i)
	var die_faces = die.get_children()
	
	return die_faces

# Updates the dice UI element based on the dice index
func update_dice_index(i):
	var die_faces = _get_die_node_faces(i)
	
	# Set dice number
	die_faces[0].texture = PlayerDiceBank.dice[i].number_icon
	
	for j in range(1, die_faces.size()):
		var face_node = die_faces[j]
		var face_obj = PlayerDiceBank.dice[i].faces[j - 1]
		
		# Reset signal if needed for updated dice
		if face_node.is_connected("mouse_entered", self, "_on_face_entered"):
			face_node.disconnect("mouse_entered", self, "_on_face_entered")
		
		# Set on hover for die face
		face_node.connect("mouse_entered", self, "_on_face_entered", [face_node, face_obj])
		
		# Set on exit if not already set
		if not face_node.is_connected("mouse_exited", self, "_on_face_exited"):
			face_node.connect("mouse_exited", self, "_on_face_exited")
		
		# Set icon
		face_node.texture = face_obj.icon
		
		# Set num value
		var num_value = face_obj.num_value
		var num_value_label = face_node.get_node("NumValue")
		
		if num_value == null or num_value == 0:
			num_value_label.text = ""
		else:
			num_value_label.text = str(num_value)

# Show or hide die selected overlay
func _die_selected_overlay(i):
	var die_selected = _get_die_node(i, _dice_col_selected)
	
	if PlayerDiceBank.dice[i].is_selected:
		die_selected.set_modulate(Color(1, 1, 1, 1))
	else:
		die_selected.set_modulate(Color(1, 1, 1, 0))

# Show or hide die used overlay
func die_used_overlay(i, is_used):
	var die_used = _get_die_node(i, _dice_col_used)
	
	if is_used:
		die_used.set_modulate(Color(1, 1, 1, 1))
		PlayerDiceBank.dice[i].is_used = true
	else:
		die_used.set_modulate(Color(1, 1, 1, 0))
		PlayerDiceBank.dice[i].is_used = false

# Move info box to position with the corresponding die info
func _on_face_entered(face_node, face_obj):
	# Do nothing if empty face name
	if face_obj.face_name == "":
		return
	
	var y_offset = Vector2(0, face_node.rect_size.y + 12)
	
	_die_face_info.set_face_info(face_obj)
	_die_face_info.set_global_position(face_node.get_global_position() - (face_node.rect_size / 1.5) + y_offset)
	
	# Set min x position to avoid displaying outside screen
	_die_face_info.rect_global_position.x = min(_die_face_info.rect_global_position.x, 555)
	
	_die_face_info.visible = true

# Hide info box after exiting a die face node
func _on_face_exited():
	_die_face_info.visible = false

# Scale up dice row on hover
func _on_die_entered(i):
	var die = _get_die_node(i)
	var die_selected = _get_die_node(i, _dice_col_selected)
	var die_used = _get_die_node(i, _dice_col_used)
	
	die.rect_scale = Vector2(1.05, 1.05)
	die_selected.rect_scale = Vector2(1.05, 1.05)
	die_used.rect_scale = Vector2(1.05, 1.05)

# Scale back dice row to original on exit
func _on_die_exited(i):
	var die = _get_die_node(i)
	var die_selected = _get_die_node(i, _dice_col_selected)
	var die_used = _get_die_node(i, _dice_col_used)
	
	die.rect_scale = Vector2(1, 1)
	die_selected.rect_scale = Vector2(1, 1)
	die_used.rect_scale = Vector2(1, 1)

# On face entered + scale up face node only
func _on_only_face_entered(face_node, face_obj):
	_on_face_entered(face_node, face_obj)
	face_node.rect_scale = Vector2(1.1, 1.1)

# On face exited + scale down face node only
func _on_only_face_exited(face_node):
	_on_face_exited()
	face_node.rect_scale = Vector2(1, 1)
