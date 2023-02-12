extends EnemyDieFace
class_name EnemyFaceBlock

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "Block"
	face_info = "Blocks " + str(num_value) + " incoming damage."
	icon = load("res://dice/faces/face-block.png")
	
	enemy_owner = enemy

func on_play(combat):
	enemy_owner.add_block(num_value)
