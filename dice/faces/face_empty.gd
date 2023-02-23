extends DieFace
class_name FaceEmpty

func _init():
	num_value = 0
	
	face_name = ""
	face_info = ""
	icon = load("res://dice/die-empty-slot.png")

func on_play(combat, target):
	pass
