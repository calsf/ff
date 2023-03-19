extends PathFace
class_name PathFaceCombat

func _init():
	face_name = "COMBAT"
	icon = load("res://map/path-faces/path-combat.png")
	next_scene = "res://Combat.tscn"
