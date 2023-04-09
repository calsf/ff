extends Node2D

const MAP_SCENE_PATH = "res://map/Map.tscn"

onready var _play_btn = $CanvasLayer/Buttons/PlayBtn
onready var _config_btn = $CanvasLayer/Buttons/ConfigBtn
onready var _quit_btn = $CanvasLayer/Buttons/QuitBtn
onready var _fade = $CanvasLayer/Fade

var hovered_option = null

func _ready():
	# Title should always been normal time scale
	Engine.time_scale = 1.0
	
	# Reset singleton vals
	PlayerHealth.reset_health()
	PlayerDiceBank.reset_dice_bank()
	LevelDepth.reset_level_depth()
	
	_play_btn.connect("mouse_entered", self, "_on_option_entered", [_play_btn])
	_config_btn.connect("mouse_entered", self, "_on_option_entered", [_config_btn])
	_quit_btn.connect("mouse_entered", self, "_on_option_entered", [_quit_btn])
	
	_play_btn.connect("mouse_exited", self, "_on_option_exited")
	_config_btn.connect("mouse_exited", self, "_on_option_exited")
	_quit_btn.connect("mouse_exited", self, "_on_option_exited")
	
	_play_btn.connect("pressed", self, "_on_play_pressed")

func _process(delta):
	# Override flashing anim by setting modulate each frame when hovered
	if hovered_option != null:
		hovered_option.set_modulate(Color(1, 1, 1, 1))

func play_title_music():
	GlobalMusic.play("Title")

func _on_play_pressed():
	_fade.go_to_scene(MAP_SCENE_PATH)
	GlobalMusic.stop_all()

func _on_option_entered(option):
	hovered_option = option

func _on_option_exited():
	hovered_option = null
