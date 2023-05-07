extends DieFace
class_name FaceBlock

func _init(value=0):
	num_value = value
	
	face_name = "BLOCK"
	face_info = "Blocks " + str(num_value) + " incoming damage."
	icon = load("res://dice/faces/face-block.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	# Apply any fortify amount first
	var val = num_value + combat.get_fortify_amount()
	
	combat.add_player_block(val)
	yield(combat.get_tree(), "idle_frame")
