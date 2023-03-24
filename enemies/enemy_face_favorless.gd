extends EnemyDieFace
class_name EnemyFaceFavorless

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "FAVORLESS"
	face_info = "Removes  " + str(num_value) + " favor."
	icon = load("res://dice/faces/face-enemy-favorless.png")
	
	enemy_owner = enemy

func on_play(combat):
	combat.remove_favor(num_value)
