extends DieFace
class_name FaceEmpty

func _init():
	num_value = 0
	
	face_name = ""
	update_info()
	icon = load("res://dice/die-empty-slot.png")

func on_play(combat, target, parent_die=0):
	pass

func update_info():
	face_info = ""
