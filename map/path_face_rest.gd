extends PathFace
class_name PathFaceRest

func _init():
	face_name = "REST"
	icon = load("res://map/path-faces/path-rest.png")
	next_scene = ""
	no_transition = true

func activate():
	var heal = 2 + LevelDepth.depth
	
	PlayerHealth.add_health(heal)
