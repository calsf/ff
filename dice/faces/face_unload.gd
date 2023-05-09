extends DieFace
class_name FaceUnload

const DEFAULT_VAL = 0

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "UNLOAD"
	face_info = "Plays all faces on this die. Excludes UNLOAD."
	icon = load("res://dice/faces/face-unload.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	for face in PlayerDiceBank.dice[parent_die].faces:
		# Skip all UNLOAD faces
		if face == self:
			continue
		
		yield(face.on_play(combat, target), "completed")
		yield(combat.get_tree().create_timer(.3), "timeout")
