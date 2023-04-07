extends Node2D

func _ready():
	# Title should always been normal time scale
	Engine.time_scale = 1.0

func play_title_music():
	GlobalMusic.play("Title")
