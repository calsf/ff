extends EnemyDieFace
class_name EnemyFacePowerUp

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "POWER UP"
	face_info = "Powering up..."
	icon = load("res://dice/faces/face-enemy-power-up.png")
	
	enemy_owner = enemy

func on_play(combat):
	pass
