extends EnemyDieFace
class_name EnemyFaceSelfDestructThree

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "COUNTDOWN: 3"
	face_info = "3..."
	icon = load("res://dice/faces/face-enemy-selfdestruct-03.png")
	
	enemy_owner = enemy

func on_play(combat):
	pass
