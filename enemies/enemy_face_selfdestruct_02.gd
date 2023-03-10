extends EnemyDieFace
class_name EnemyFaceSelfDestructTwo

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "COUNTDOWN: 2"
	face_info = "2..."
	icon = load("res://dice/faces/face-enemy-selfdestruct-02.png")
	
	enemy_owner = enemy

func on_play(combat):
	pass
