extends DieFace
class_name FaceHeal

func _init(value=0):
	num_value = value
	
	face_name = "HEAL"
	face_info = "Recover " + str(num_value) + " health."
	icon = load("res://dice/faces/face-heal.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	combat.add_health(num_value)
	yield(combat.get_tree(), "idle_frame")
