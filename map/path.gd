extends Node2D

onready var _path_area = $PathArea
onready var _path_area_faces = $PathArea/PathFaces

func get_path_faces():
	return _path_area_faces.get_children()
