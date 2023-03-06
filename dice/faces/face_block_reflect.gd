extends DieFace
class_name FaceBlockReflect

func _init(value=0):
	num_value = value
	
	face_name = "BLOCK REFLECT"
	face_info = "Blocks " + str(num_value) + " incoming damage. Block will reflect half of damage blocked."
	icon = load("res://dice/faces/face-block-reflect.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	combat.add_player_block(num_value)
	combat.set_reflect(true)
	yield(combat.get_tree(), "idle_frame")
