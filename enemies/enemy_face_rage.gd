extends EnemyDieFace
class_name EnemyFaceRage

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "RAGE"
	face_info = "Deal damage equal to 50% of missing health to a single target."
	icon = load("res://dice/faces/face-rage.png")
	
	enemy_owner = enemy

func on_play(combat):
	var num = (enemy_owner.max_health - enemy_owner.health) / 2
	combat.deal_blockable_player_damage(num, enemy_owner)
