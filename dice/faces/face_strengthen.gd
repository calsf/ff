extends DieFace
class_name FaceStrengthen

const DEFAULT_VAL = 3
const SCALING = 2

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "STRENGTHEN"
	face_info = "Add " + str(num_value) + " damage to all damage sources for this combat."
	icon = load("res://dice/faces/face-strengthen.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	combat.add_strengthen(num_value)
	yield(combat.get_tree(), "idle_frame")
