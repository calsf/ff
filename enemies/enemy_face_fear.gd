extends EnemyDieFace
class_name EnemyFaceFear

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "FEAR"
	face_info = "Fear has set in..."
	icon = load("res://dice/faces/face-enemy-fear.png")
	
	enemy_owner = enemy

func on_play(combat):
	pass
