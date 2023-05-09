extends DieFace
class_name FaceChargeAttack

const DEFAULT_VAL = 5
const SCALING = 2

var status_icon = "res://combat/StatusIconChargeAttack.tscn"

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "CHARGED ATTACK"
	face_info = "Deals " + str(num_value) + " damage to a single target. Deals " + str(num_value * 2) + " damage to same target next turn."
	icon = load("res://dice/faces/face-charge-attack.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	# Apply any strengthen amount first
	var val = num_value + combat.get_strengthen_amount()
	
	target.deal_blockable_damage(val, combat)
	combat.add_extra_face(self, target, status_icon)
	yield(combat.get_tree(), "idle_frame")

func on_extra_play(combat, target):
	# Apply double damage first
	var val = num_value * 2
	
	# Apply any strengthen amount after
	val += combat.get_strengthen_amount()
	
	target.deal_blockable_damage(val, combat)
	yield(combat.get_tree(), "idle_frame")
