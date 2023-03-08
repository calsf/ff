extends DieFace
class_name FaceAttackBlock

func _init(value=0):
	num_value = value
	
	face_name = "ATTACK BLOCK"
	face_info = "Deal " + str(num_value) + " damage and block " + str(num_value) + " incoming damage."
	icon = load("res://dice/faces/face-attack-block.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	target.deal_blockable_damage(num_value, combat)
	combat.add_player_block(num_value)
	yield(combat.get_tree(), "idle_frame")
