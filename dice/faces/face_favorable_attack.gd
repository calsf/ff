extends DieFace
class_name FaceFavorableAttack

const DEFAULT_VAL = 0
const SCALING = 0

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "FAVORABLE ATTACK"
	update_info()
	icon = load("res://dice/faces/face-favorable-attack.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	var num = combat.favor
	combat.remove_favor(num)
	
	# Apply triple damage first
	var val = num * 3
	
	# Apply any strengthen amount after
	val += combat.get_strengthen_amount()
	
	target.deal_blockable_damage(val, combat)
	yield(combat.get_tree(), "idle_frame")

func update_info():
	face_info = "Spend all favor. Deal damage equal to 3x of favor spent."
