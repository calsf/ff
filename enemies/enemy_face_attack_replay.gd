extends EnemyDieFace
class_name EnemyFaceAttackReplay

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "ATTACK REPLAY"
	face_info = "Deals " + str(num_value) + " damage. Repeats turn."
	icon = load("res://dice/faces/face-enemy-attack-replay.png")
	
	enemy_owner = enemy

func on_play(combat):
	combat.deal_blockable_player_damage(num_value, enemy_owner)
	combat.set_enemy_replay(true)
