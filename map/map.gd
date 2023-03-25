extends Node2D

onready var _map_fade_anim = $CanvasLayer/MapFade/AnimationPlayer
onready var _fade = $CanvasLayer/Fade
onready var _canvas = $CanvasLayer

onready var _map_area = $MapArea
onready var _path_start = $MapArea/PathStart
onready var _player = $MapArea/PlayerNode

onready var _move_btn = $CanvasLayer/MoveBtn
onready var _set_path_btn = $CanvasLayer/SetPathBtn

onready var _paths_info = $CanvasLayer/PathsInfo

func _ready():
	_canvas.layer = 0
	
	# TEMP
	$CanvasLayer/TEMPRESETBTN.connect("pressed", self, "reset_map")

func hide_map():
	self.visible = false
	_fade.hide()
	_fade.reset_fade()

func show_map():
	self.visible = true
	_fade.show()
	_fade.fade_out()
	_fade.reset_fade()
	
	# Make sure to enable move button upon showing map
	_move_btn.enable_move()

func reset_map():
	_move_btn.disable_move()
	_set_path_btn.disable_set_path()
	_map_fade_anim.play("FadeInAndOut")
	
	# Wait amount of time until fade fills map area, then reset behind the scenes
	yield(get_tree().create_timer(.6), "timeout")
	
	# Re-initialize map
	_map_area.initialize_start()
	
	# Reset paths
	_paths_info.reset_paths()
	
	# Cancel any actions
	_move_btn.cancel_move_options()
	_set_path_btn.cancel_set_path()
	
	# Free all map area children except for player and path start
	for child in _map_area.get_children():
		if child == _path_start or child == _player:
			continue
		child.queue_free()
	
	# Reset buttons after anim is done
	yield(_map_fade_anim, "animation_finished")
	_move_btn.enable_move()
	_set_path_btn.enable_set_path()
