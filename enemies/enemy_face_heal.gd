extends EnemyDieFace
class_name EnemyFaceHeal

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "HEAL"
	face_info = "Recover " + str(num_value) + " health."
	icon = load("res://dice/faces/face-heal.png")
	
	enemy_owner = enemy

func on_play(combat):
	enemy_owner.add_health(num_value)
