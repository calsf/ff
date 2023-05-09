extends DieFace
class_name FaceRage

const DEFAULT_VAL = 0
const SCALING = 0

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "RAGE"
	face_info = "Deal damage equal to 50% of missing health to a single target."
	icon = load("res://dice/faces/face-rage.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	var num = (PlayerHealth.MAX_HP - PlayerHealth.curr_hp) / 2
	
	# Apply any strengthen amount after
	var val = num + combat.get_strengthen_amount()
	
	target.deal_blockable_damage(val, combat)
	yield(combat.get_tree(), "idle_frame")
