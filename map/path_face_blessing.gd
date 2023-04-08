extends PathFace
class_name PathFaceBlessing

func _init():
	face_name = "BLESSING"
	icon = load("res://map/path-faces/path-blessing.png")
	next_scene = "res://combat/Combat.tscn"
