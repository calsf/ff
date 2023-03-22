extends Node2D

onready var _fade = $CanvasLayer/Fade
onready var _canvas = $CanvasLayer

func _ready():
	_canvas.layer = 0

func hide_map():
	self.visible = false
	_fade.hide()
	_fade.reset_fade()

func show_map():
	self.visible = true
	_fade.show()
	_fade.fade_out()
	_fade.reset_fade()
