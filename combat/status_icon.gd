extends Control
class_name StatusIcon

var status_name : String
var status_info : String

onready var _die_face_info = get_tree().get_root().get_node("Encounter/CanvasLayer/DieFaceInfo")

func _ready():
	_init_info()
	self.connect("mouse_entered", self, "_on_icon_entered")
	self.connect("mouse_exited", self, "_on_icon_exited")

func _on_icon_entered():
	_die_face_info.set_face_info_directly(status_name, status_info)
	
	var target = self
	var y_offset = Vector2(0, (target.rect_size.y * 3.5))
	
	_die_face_info.set_global_position(target.rect_global_position - Vector2((target.rect_size.x * 1.5), 0) - y_offset)
	
	_die_face_info.visible = true

func _on_icon_exited():
	_die_face_info.visible = false

func set_info(face, target):
	pass

func _init_info():
	pass
