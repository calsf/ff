extends DieFace
class_name FaceChargeAttack

func _init(value=0):
	num_value = value
	
	face_name = "CHARGED ATTACK"
	face_info = "Deals " + str(num_value) + " damage to a single target. Deals " + str(num_value * 2) + " damage to same target next turn."
	icon = load("res://dice/faces/face-charge-attack.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	target.deal_blockable_damage(num_value)
	combat.extra_faces.append(self)
	combat.extra_faces_target.append(target)
	yield(combat.get_tree(), "idle_frame")

func on_extra_play(combat, target):
	target.deal_blockable_damage(num_value * 2)
	yield(combat.get_tree(), "idle_frame")
