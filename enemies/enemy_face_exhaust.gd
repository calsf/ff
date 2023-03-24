extends EnemyDieFace
class_name EnemyFaceExhaust

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "EXHAUST"
	face_info = "Disables all dice until next reload. Reloads 1 random die."
	icon = load("res://dice/faces/face-enemy-exhaust.png")
	
	enemy_owner = enemy

func on_play(combat):
	combat.enemy_exhaust_face()
