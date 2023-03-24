extends DieFace
class_name FaceAttack

func _init(value=0):
	num_value = value
	
	face_name = "ATTACK"
	face_info = "Deals " + str(num_value) + " damage to a single target."
	icon = load("res://dice/faces/face-attack.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	# Apply any strengthen amount first
	var val = num_value + combat.get_strengthen_amount()
	
	target.deal_blockable_damage(val, combat)
	yield(combat.get_tree(), "idle_frame")
