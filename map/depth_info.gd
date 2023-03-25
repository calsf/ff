extends Control

onready var _depth_label = $Depth/Label
onready var _depth = $Depth

onready var _die_face_info = get_tree().get_root().get_node("Map/CanvasLayer/DieFaceInfo")

func _ready():
	LevelDepth.connect("depth_updated", self, "_update_depth")
	
	_depth.connect("mouse_entered", self, "_on_depth_entered")
	_depth.connect("mouse_exited", self, "_on_depth_exited")
	
	_update_depth()

func _update_depth():
	_depth_label.text = str(LevelDepth.depth)

func _on_depth_entered():
	var y_offset = Vector2(0, _depth.rect_size.y + 42)
	
	_die_face_info.set_face_info_directly("CURRENT DEPTH", "Clear this floor's guardian to advance to the next depth.")
	_die_face_info.set_global_position(_depth.get_global_position() - (_depth.rect_size / 1.05) - y_offset)
	
	_die_face_info.visible = true

func _on_depth_exited():
	_die_face_info.visible = false
