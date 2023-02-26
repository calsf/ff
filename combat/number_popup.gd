extends Control

onready var _label = $Label
onready var _anim = $AnimationPlayer

func _ready():
	self.visible = false

func set_and_activate_label(text, color, original_label):
	_label.text = text
	_label.set("custom_colors/font_color", color)
	_label.set("custom_fonts/font/size", original_label.get("custom_fonts/font/size"))
	_label.align = original_label.align
	_label.valign = original_label.valign
	
	self.set_size(original_label.get_size())
	self.set_position(original_label.get_global_position())
	self.visible = true
	
	_anim.play("popup")
