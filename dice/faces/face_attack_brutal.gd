extends DieFace
class_name FaceAttackBrutal

func _init(value=0):
	num_value = value
	
	face_name = "BRUTAL ATTACK"
	face_info = "Deals " + str(num_value) + " damage to a single target. Ignores block."
	icon = load("res://dice/faces/face-attack-brutal.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	target.deal_direct_damage(num_value)
	yield(combat.get_tree(), "idle_frame")
