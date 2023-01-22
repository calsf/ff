extends DieFace
class_name FaceBlock

func _init(value=0):
	num_value = value
	
	face_name = "Block"
	face_info = "Blocks " + str(num_value) + " incoming damage."
	icon = load("res://dice-bank/faces/face-block.png")

func on_play():
	pass
