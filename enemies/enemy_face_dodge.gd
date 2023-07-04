extends EnemyDieFace
class_name EnemyFaceDodge

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "DODGE"
	face_info = "Gain dodge. Dodge avoids all damage."
	icon = load("res://dice/faces/face-dodge.png")
	
	enemy_owner = enemy

func on_play(combat):
	enemy_owner.set_dodge(true)
