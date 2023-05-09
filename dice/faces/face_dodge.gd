extends DieFace
class_name FaceDodge

const DEFAULT_VAL = 0

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "DODGE"
	face_info = "Avoids all damage."
	icon = load("res://dice/faces/face-dodge.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	combat.set_dodge(true)
	yield(combat.get_tree(), "idle_frame")
