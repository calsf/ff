extends DieFace
class_name FaceReplay

const DEFAULT_VAL = 0
const SCALING = 0

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "REPLAY"
	face_info = "Repeat your turn."
	icon = load("res://dice/faces/face-replay.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	combat.set_replay(true)
	yield(combat.get_tree(), "idle_frame")
