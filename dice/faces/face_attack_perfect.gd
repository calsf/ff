extends DieFace
class_name FaceAttackPerfect

func _init(value=0):
	num_value = value
	
	face_name = "PERFECT ATTACK"
	face_info = "Deals " + str(num_value) + " damage to a single target. Ignores block and dodge."
	icon = load("res://dice/faces/face-attack-perfect.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	target.deal_direct_damage(num_value, true)
	yield(combat.get_tree(), "idle_frame")
