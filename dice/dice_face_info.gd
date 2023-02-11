extends Control

onready var name_label = $Name/NameLabel
onready var info_label = $Info

func _ready():
	visible = false

func set_face_info(face):
	name_label.text = face.face_name
	info_label.text = face.face_info
