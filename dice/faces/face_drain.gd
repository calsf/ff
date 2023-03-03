extends DieFace
class_name FaceDrain

func _init(value=0):
	num_value = value
	
	face_name = "DRAIN"
	face_info = "Deals " + str(num_value) + " damage to a single target. Heal for damage dealt."
	icon = load("res://dice/faces/face-drain.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	var heal_amount = yield(target.deal_blockable_damage(num_value), "completed")
	combat.add_health(heal_amount)
	yield(combat.get_tree(), "idle_frame")
