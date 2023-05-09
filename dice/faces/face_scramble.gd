extends DieFace
class_name FaceScramble

const DEFAULT_VAL = 0
const SCALING = 0

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "SCRAMBLE"
	face_info = "Randomize target's next action."
	icon = load("res://dice/faces/face-scramble.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	target.set_next_intent()
	
	# Play anim to reset enemy intents
	var anim_to_wait_for = null
	anim_to_wait_for = target.get_node("IntentAnimPlayer")
	anim_to_wait_for.play("roll")
	
	if anim_to_wait_for != null:
		yield(anim_to_wait_for, "animation_finished")
