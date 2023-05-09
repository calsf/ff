extends DieFace
class_name FaceAttackBlock

const DEFAULT_VAL = 5

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "ATTACK BLOCK"
	face_info = "Deal " + str(num_value) + " damage and block " + str(num_value) + " incoming damage."
	icon = load("res://dice/faces/face-attack-block.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	# Apply any strengthen amount first
	var val = num_value + combat.get_strengthen_amount()
	
	# Apply any fortify amount first
	var fortified_val = num_value + combat.get_fortify_amount()
	
	target.deal_blockable_damage(val, combat)
	combat.add_player_block(fortified_val)
	yield(combat.get_tree(), "idle_frame")
