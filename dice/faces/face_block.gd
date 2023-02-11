extends DieFace
class_name FaceBlock

func _init(value=0):
	num_value = value
	
	face_name = "Block"
	face_info = "Blocks " + str(num_value) + " incoming damage."
	icon = load("res://dice/faces/face-block.png")
	
	require_target = false

func on_play(combat):
	combat.add_player_block(num_value)
