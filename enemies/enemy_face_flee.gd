extends EnemyDieFace
class_name EnemyFaceFlee

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "FLEE"
	face_info = "Escape from combat, taking allies and loot with them."
	icon = load("res://dice/faces/face-enemy-flee.png")
	
	enemy_owner = enemy

func on_play(combat):
	combat.enemy_fled = true
