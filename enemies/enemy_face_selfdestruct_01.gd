extends EnemyDieFace
class_name EnemyFaceSelfDestructOne

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "COUNTDOWN: 1"
	face_info = "1..."
	icon = load("res://dice/faces/face-enemy-selfdestruct-01.png")
	
	enemy_owner = enemy

func on_play(combat):
	pass
