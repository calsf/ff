extends Control

onready var _back_btn = $BackBtn
onready var _dice_col = $HBoxDice
onready var _health_label = $HBoxStats/Health/Label
onready var _starting_favor_label = $HBoxStats/StartingFavor/Label
onready var _depth_label = $HBoxStats/Depth/Label
onready var _run_label = $RunLabel
onready var _die_face_info = get_tree().get_root().get_node("Title/CanvasLayer/Logs/DieFaceInfo")

func _ready():
	_back_btn.connect("pressed", self, "_on_back_pressed")

func set_and_display(data):
	_health_label.text = str(data["health"])
	_starting_favor_label.text = str(data["starting_favor"])
	_depth_label.text = str(data["depth"])
	_run_label.text = str(data["label"])
	
	for i in range(data["dice"].size()):
		update_dice_index(data["dice"], i)
	
	self.visible = true

func _on_back_pressed():
	self.visible = false
	
	GlobalSounds.play("ButtonPressed")

### Copied from DiceBank.gd ###
func get_dice_nodes():
	var dice = []
	
	for col in range(_dice_col.get_children().size()):
		for row in range(_dice_col.get_child(col).get_children().size()):
			dice.append(_dice_col.get_child(col).get_child(row))
	
	return dice

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
# Updated to use given data instead of player dice bank
func update_dice_index(data, i):
	var die_faces = _get_die_node_faces(i)
	
	# Set dice number
	die_faces[0].texture = PlayerDiceBank.dice[i].number_icon
	
	for j in range(1, die_faces.size()):
		var face_node = die_faces[j]
		var face_obj = data[i].faces[j - 1]
		
		# Reset signal if needed for updated dice
		if face_node.is_connected("mouse_entered", self, "_on_face_entered"):
			face_node.disconnect("mouse_entered", self, "_on_face_entered")
		
		# Set on hover for die face
		face_node.connect("mouse_entered", self, "_on_face_entered", [face_node, face_obj])
		
		# Set on exit if not already set
		if not face_node.is_connected("mouse_exited", self, "_on_face_exited"):
			face_node.connect("mouse_exited", self, "_on_face_exited")
		
		# Set icon
		face_node.texture = load(face_obj.icon)
		
		# Set num value
		var num_value = face_obj.num_value
		var num_value_label = face_node.get_node("NumValue")
		
		if num_value == null or num_value == 0:
			num_value_label.text = ""
		else:
			num_value_label.text = str(num_value)

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
