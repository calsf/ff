extends DieFace
class_name FaceCheapFavor

func _init(value=0):
	num_value = value
	
	face_name = "CHEAP FAVOR"
	face_info = "Deals " + str(num_value) + " damage to a single target. Gain favor for unblocked damage dealt."
	icon = load("res://dice/faces/face-cheap-favor.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	var favor_amount = yield(target.deal_blockable_damage(num_value, combat), "completed")
	combat.add_favor(favor_amount)
	yield(combat.get_tree(), "idle_frame")

