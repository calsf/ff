extends DieFace
class_name FaceDodge

func _init(value=0):
	num_value = value
	
	face_name = "DODGE"
	face_info = "Avoids all damage."
	icon = load("res://dice/faces/face-dodge.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	combat.dodge = true
	yield(combat.get_tree(), "idle_frame")
