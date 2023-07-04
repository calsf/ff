extends DieFace
class_name FaceMultiAttack

const DEFAULT_VAL = 3
const SCALING = 2

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "MULTIATTACK"
	update_info()
	icon = load("res://dice/faces/face-multiattack.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	# Apply any strengthen amount first
	var val = num_value + combat.get_strengthen_amount()
	
	for enemy in combat.enemies:
		if not enemy.is_dead:
			enemy.deal_blockable_damage(val, combat)
	yield(combat.get_tree(), "idle_frame")

func update_info():
	face_info = "Deal " + str(num_value) + " damage to all enemies."
