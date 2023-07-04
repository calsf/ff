extends DieFace
class_name FaceBlockReflect

const DEFAULT_VAL = 5
const SCALING = 2

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "BLOCK REFLECT"
	update_info()
	icon = load("res://dice/faces/face-block-reflect.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	# Apply any fortify amount first
	var val = num_value + combat.get_fortify_amount()
	
	combat.add_player_block(val)
	combat.set_reflect(true)
	yield(combat.get_tree(), "idle_frame")

func update_info():
	face_info = "Gain " + str(num_value) + " block. Block will also reflect half of damage blocked."
