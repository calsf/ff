extends DieFace
class_name FaceAttackBrutal

const DEFAULT_VAL = 5

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "BRUTAL ATTACK"
	face_info = "Deals " + str(num_value) + " damage to a single target. Ignores block."
	icon = load("res://dice/faces/face-attack-brutal.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	# Apply any strengthen amount first
	var val = num_value + combat.get_strengthen_amount()
	
	target.deal_direct_damage(val, combat)
	yield(combat.get_tree(), "idle_frame")
