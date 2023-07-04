extends EnemyDieFace
class_name EnemyFaceAttackBrutal

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "BRUTAL ATTACK"
	face_info = "Deal " + str(num_value) + " damage. Ignores block."
	icon = load("res://dice/faces/face-attack-brutal.png")
	
	enemy_owner = enemy

func on_play(combat):
	combat.deal_direct_player_damage(num_value)
