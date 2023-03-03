extends DieFace
class_name FaceReplay

func _init(value=0):
	num_value = value
	
	face_name = "REPLAY"
	face_info = "Repeat your turn."
	icon = load("res://dice/faces/face-replay.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	combat.replay = true
	yield(combat.get_tree(), "idle_frame")
