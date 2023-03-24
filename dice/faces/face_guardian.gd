extends DieFace
class_name FaceGuardian

func _init(value=0):
	num_value = value
	
	face_name = "GUARDIAN"
	face_info = "Next fatal hit will be avoided."
	icon = load("res://dice/faces/face-guardian.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	combat.set_guardian(true)
	yield(combat.get_tree(), "idle_frame")
