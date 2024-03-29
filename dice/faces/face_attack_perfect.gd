extends DieFace
class_name FaceAttackPerfect

const DEFAULT_VAL = 5
const SCALING = 2

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "PERFECT ATTACK"
	update_info()
	icon = load("res://dice/faces/face-attack-perfect.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	# Apply any strengthen amount first
	var val = num_value + combat.get_strengthen_amount()
	
	target.deal_direct_damage(val, combat, true)
	yield(combat.get_tree(), "idle_frame")

func update_info():
	face_info = "Deal " + str(num_value) + " damage. Ignores block and dodge."
