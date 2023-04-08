extends Node2D

const MAP_SCENE_PATH = "res://map/Map.tscn"

onready var _play_btn = $CanvasLayer/Buttons/PlayBtn
onready var _fade = $CanvasLayer/Fade

func _ready():
	# Title should always been normal time scale
	Engine.time_scale = 1.0
	
	# Reset singleton vals
	PlayerHealth.reset_health()
	PlayerDiceBank.reset_dice_bank()
	LevelDepth.reset_level_depth()
	
	_play_btn.connect("pressed", self, "_on_play_pressed")

func play_title_music():
	GlobalMusic.play("Title")

func _on_play_pressed():
	_fade.go_to_scene(MAP_SCENE_PATH)
	GlobalMusic.stop_all()
