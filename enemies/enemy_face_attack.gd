extends EnemyDieFace
class_name EnemyFaceAttack

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "ATTACK"
	face_info = "Deals " + str(num_value) + " damage."
	icon = load("res://dice/faces/face-attack.png")
	
	enemy_owner = enemy

func on_play(combat):
	combat.deal_blockable_player_damage(num_value, enemy_owner)
