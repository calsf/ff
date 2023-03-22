extends PathFace
class_name PathFaceChest

func _init():
	face_name = "CHEST"
	icon = load("res://map/path-faces/path-chest.png")
	next_scene = "res://Combat.tscn"
