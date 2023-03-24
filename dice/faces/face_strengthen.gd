extends DieFace
class_name FaceStrengthen

func _init(value=0):
	num_value = value
	
	face_name = "STRENGTHEN"
	face_info = "Add " + str(num_value) + " damage to all damage sources for this combat."
	icon = load("res://dice/faces/face-strengthen.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	combat.add_strengthen(num_value)
	yield(combat.get_tree(), "idle_frame")
