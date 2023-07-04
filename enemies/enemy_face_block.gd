extends EnemyDieFace
class_name EnemyFaceBlock

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "BLOCK"
	face_info = "Gain " + str(num_value) + " block. Block reduces incoming damage."
	icon = load("res://dice/faces/face-block.png")
	
	enemy_owner = enemy

func on_play(combat):
	enemy_owner.add_block(num_value)
