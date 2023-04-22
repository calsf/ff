extends Node

onready var _anim = $AnimationPlayer
onready var _face = $Face
onready var _num_value_label = $NumValue

func play_anim(anim):
	_anim.play(anim)

func set_face(icon, num_value):
	self.texture = icon
	_face.texture = icon
	
	if num_value == null or num_value == 0:
		_num_value_label.text = ""
	else:
		_num_value_label.text = str(num_value)

func play_set_sound():
	GlobalSounds.play("Set")

func play_discard_sound():
	GlobalSounds.play("Discard")
