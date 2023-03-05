extends DieFace
class_name FaceAttack

func _init(value=0):
	num_value = value
	
	face_name = "ATTACK"
	face_info = "Deals " + str(num_value) + " damage to a single target."
	icon = load("res://dice/faces/face-attack.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	target.deal_blockable_damage(num_value)
	yield(combat.get_tree(), "idle_frame")
