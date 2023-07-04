extends EnemyDieFace
class_name EnemyFaceBlockAll

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "BLOCK ALL"
	face_info = "Gain " + str(num_value) + " block for self and allies."
	icon = load("res://dice/faces/face-enemy-block-all.png")
	
	enemy_owner = enemy

func on_play(combat):
	for enemy in combat.enemies:
		if not enemy.is_dead:
			enemy.add_block(num_value)
