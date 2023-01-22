extends NinePatchRect

onready var _dice_col = $HBoxDice

func _ready():
	# NEED TO MAKE SURE PLAYERDICEBANK.DICE HAS BEEN INITIALIZED BEFORE THIS
	
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
