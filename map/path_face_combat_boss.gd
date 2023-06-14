extends PathFace
class_name PathFaceCombatBoss

func _init():
	face_name = "COMBAT BOSS"
	icon = load("res://map/path-faces/path-combat-boss.png")
	next_scene = "res://combatboss/CombatBoss.tscn"
