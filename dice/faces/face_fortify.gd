extends DieFace
class_name FaceFortify

func _init(value=0):
	num_value = value
	
	face_name = "FORTIFY"
	face_info = "Add " + str(num_value) + " block to all block sources for this combat."
	icon = load("res://dice/faces/face-fortify.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	combat.add_fortify(num_value)
	yield(combat.get_tree(), "idle_frame")
