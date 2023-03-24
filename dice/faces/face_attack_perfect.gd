extends DieFace
class_name FaceAttackPerfect

func _init(value=0):
	num_value = value
	
	face_name = "PERFECT ATTACK"
	face_info = "Deals " + str(num_value) + " damage to a single target. Ignores block and dodge."
	icon = load("res://dice/faces/face-attack-perfect.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	# Apply any strengthen amount first
	var val = num_value + combat.get_strengthen_amount()
	
	target.deal_direct_damage(val, combat, true)
	yield(combat.get_tree(), "idle_frame")
