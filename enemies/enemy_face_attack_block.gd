extends EnemyDieFace
class_name EnemyFaceAttackBlock

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "ATTACK BLOCK"
	face_info = "Deal " + str(num_value) + " damage and gain " + str(num_value) + " block."
	icon = load("res://dice/faces/face-attack-block.png")
	
	enemy_owner = enemy

func on_play(combat):
	combat.deal_blockable_player_damage(num_value, enemy_owner)
	enemy_owner.add_block(num_value)
