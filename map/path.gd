extends Node2D

onready var _path_area = $PathArea
onready var _path_area_faces = $PathArea/PathFaces

func _ready():
	if _path_area is PathArea:
		disable_path()

func get_path_faces():
	return _path_area_faces.get_children()

func disable_path():
	_path_area.is_disabled = true
	self.visible = false

func enable_path():
	_path_area.is_disabled = false
	self.visible = true
