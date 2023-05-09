extends DieFace
class_name FaceGuardian

const DEFAULT_VAL = 0
const SCALING = 0

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "GUARDIAN"
	face_info = "Next fatal hit will be avoided."
	icon = load("res://dice/faces/face-guardian.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	combat.set_guardian(true)
	yield(combat.get_tree(), "idle_frame")
