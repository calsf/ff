extends DieFace
class_name FaceDrain

const DEFAULT_VAL = 5
const SCALING = 2

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "DRAIN"
	update_info()
	icon = load("res://dice/faces/face-drain.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	# Apply any strengthen amount first
	var val = num_value + combat.get_strengthen_amount()
	
	var heal_amount = yield(target.deal_blockable_damage(val, combat), "completed")
	combat.add_health(heal_amount)
	yield(combat.get_tree(), "idle_frame")

func update_info():
	face_info = "Deals " + str(num_value) + " damage to a single target. Heal for unblocked damage dealt."
