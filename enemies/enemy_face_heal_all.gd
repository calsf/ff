extends EnemyDieFace
class_name EnemyFaceHealAll

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "HEAL ALL"
	face_info = "Recover " + str(num_value) + " health for self and allies."
	icon = load("res://dice/faces/face-enemy-heal-all.png")
	
	enemy_owner = enemy

func on_play(combat):
	for enemy in combat.enemies:
		if not enemy.is_dead:
			enemy.add_health(num_value)
