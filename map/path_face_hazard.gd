extends PathFace
class_name PathFaceHazard

func _init():
	face_name = "HAZARD"
	icon = load("res://map/path-faces/path-hazard.png")
	next_scene = ""
	no_transition = true

func activate():
	var damage = 2 + LevelDepth.depth
	if PlayerHealth.curr_hp <= damage:
		damage = PlayerHealth.curr_hp - 1
	
	PlayerHealth.lose_health(damage)
