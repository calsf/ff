extends PathFace
class_name PathFaceHazard

func _init():
	face_name = "HAZARD"
	icon = load("res://map/path-faces/path-hazard.png")
	next_scene = "res://combat/Combat.tscn"
