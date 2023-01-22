extends DieFace
class_name FaceAttack

func _init(value=0):
	num_value = value
	
	face_name = "Attack"
	face_info = "Deals " + str(num_value) + " damage to a single target."
	icon = load("res://dice-bank/faces/face-attack.png")

func on_play():
	pass
