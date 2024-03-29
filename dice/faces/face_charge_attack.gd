extends DieFace
class_name FaceChargeAttack

const DEFAULT_VAL = 5
const SCALING = 2

var status_icon = "res://combat/StatusIconChargeAttack.tscn"

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "CHARGED ATTACK"
	update_info()
	icon = load("res://dice/faces/face-charge-attack.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	# Apply any strengthen amount first
	var val = num_value + combat.get_strengthen_amount()
	
	target.deal_blockable_damage(val, combat)
	combat.add_extra_face(self, target, status_icon)
	yield(combat.get_tree(), "idle_frame")

func on_extra_play(combat, target):
	if target.is_dead:
		yield(combat.get_tree(), "idle_frame")
		return
	
	# Apply double damage first
	var val = num_value * 2
	
	# Apply any strengthen amount after
	val += combat.get_strengthen_amount()
	
	target.deal_blockable_damage(val, combat)
	yield(combat.get_tree(), "idle_frame")

func update_info():
	face_info = "Deal " + str(num_value) + " damage. Deal " + str(num_value * 2) + " damage to same enemy next turn."
