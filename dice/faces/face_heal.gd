extends DieFace
class_name FaceHeal

const DEFAULT_VAL = 10
const SCALING = 5

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "HEAL"
	update_info()
	icon = load("res://dice/faces/face-heal.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	combat.add_health(num_value)
	yield(combat.get_tree(), "idle_frame")

func update_info():
	face_info = "Recover " + str(num_value) + " health."
