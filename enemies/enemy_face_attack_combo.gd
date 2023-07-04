extends EnemyDieFace
class_name EnemyFaceAttackCombo

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "COMBO ATTACK"
	face_info = "Deal " + str(num_value) + " damage. Next attack deals +2 damage."
	icon = load("res://dice/faces/face-enemy-attack-combo.png")
	
	enemy_owner = enemy

func on_play(combat):
	combat.deal_blockable_player_damage(num_value, enemy_owner)
	num_value += 2
	face_info = "Deals " + str(num_value) + " damage. Next attack deals +2 damage."
