extends DieFace
class_name FaceCheapFavor

const DEFAULT_VAL = 3

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "CHEAP FAVOR"
	face_info = "Deals " + str(num_value) + " damage to a single target. Gain favor for unblocked damage dealt."
	icon = load("res://dice/faces/face-cheap-favor.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	# Apply any strengthen amount first
	var val = num_value + combat.get_strengthen_amount()
	
	var favor_amount = yield(target.deal_blockable_damage(val, combat), "completed")
	combat.add_favor(favor_amount)
	yield(combat.get_tree(), "idle_frame")

