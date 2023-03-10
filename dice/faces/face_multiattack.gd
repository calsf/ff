extends DieFace
class_name FaceMultiAttack

func _init(value=0):
	num_value = value
	
	face_name = "MULTIATTACK"
	face_info = "Deals " + str(num_value) + " damage to all enemies."
	icon = load("res://dice/faces/face-multiattack.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	for enemy in combat.enemies:
		enemy.deal_blockable_damage(num_value, combat)
	yield(combat.get_tree(), "idle_frame")
