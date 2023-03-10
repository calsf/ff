extends EnemyDieFace
class_name EnemyFaceAttackPerfect

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "PERFECT ATTACK"
	face_info = "Deals " + str(num_value) + " damage. Ignores block and dodge."
	icon = load("res://dice/faces/face-attack-perfect.png")
	
	enemy_owner = enemy

func on_play(combat):
	combat.deal_direct_player_damage(num_value, true)
