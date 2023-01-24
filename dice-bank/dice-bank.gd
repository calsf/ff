extends NinePatchRect

onready var _dice_col = $HBoxDice

onready var _dice_bar = get_tree().current_scene.get_node("CanvasLayer/DiceBar")

func _ready():
	# Set up on click events for each die in the dice bank
	var dice = []
	
	for col in range(_dice_col.get_children().size()):
		for row in range(_dice_col.get_child(col).get_children().size()):
			dice.append(_dice_col.get_child(col).get_child(row))

	for i in range(dice.size()):
		dice[i].connect("gui_input", self, "_on_die_pressed", [PlayerDiceBank.dice[i]])
	
	# NEED TO MAKE SURE PLAYERDICEBANK.DICE HAS BEEN INITIALIZED BEFORE THIS
	# Initialize all the dice UI elements
	for i in range(PlayerDiceBank.dice.size()):
		update_dice_index(i)
			

# Updates the dice UI element based on the dice index
func update_dice_index(i):
	
	# Max index, can only be 12 dice
	if (i > 11):
		return
	
	var col = i / 3
	var row = ( (i - (col * 3)) * 3) / 3
	
	var die = _dice_col.get_child(col).get_child(row)
	var die_faces = die.get_children()
	
	# Set dice number
	die_faces[0].texture = PlayerDiceBank.dice[i].number_icon
	
	for j in range(1, die_faces.size()):
		var face_node = die_faces[j]
		var face_obj = PlayerDiceBank.dice[i].faces[j - 1]
		
		# Set icon
		face_node.texture = face_obj.icon
		
		# Set num value
		var num_value = face_obj.num_value
		var num_value_label = face_node.get_node("NumValue")
		
		if num_value == null or num_value == 0:
			num_value_label.text = ""
		else:
			num_value_label.text = str(num_value)

# LMB -> add die to dice bar, RMB -> remove die from dice bar
func _on_die_pressed(event, die):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			_dice_bar.add_die(die)
		if event.button_index == BUTTON_RIGHT and event.pressed:
			_dice_bar.remove_die(die)
