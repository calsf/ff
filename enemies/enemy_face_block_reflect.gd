extends EnemyDieFace
class_name EnemyFaceBlockReflect

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "BLOCK REFLECT"
	face_info = "Blocks " + str(num_value) + " incoming damage. Block will reflect half of damage blocked."
	icon = load("res://dice/faces/face-block-reflect.png")
	
	enemy_owner = enemy

func on_play(combat):
	enemy_owner.add_block(num_value)
	enemy_owner.set_reflect(true)

