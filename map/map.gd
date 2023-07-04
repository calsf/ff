extends Node2D

# Percentage of health to heal player when resetting map
const HEAL_PERCENTAGE = .20

onready var _map_fade_anim = $CanvasLayer/MapFade/AnimationPlayer
onready var _fade = $CanvasLayer/Fade
onready var _canvas = $CanvasLayer

onready var _map_area = $MapArea
onready var _path_start = $MapArea/PathStart
onready var _player = $MapArea/PlayerNode

onready var _move_btn = $CanvasLayer/MoveBtn
onready var _set_path_btn = $CanvasLayer/SetPathBtn

onready var _paths_info = $CanvasLayer/PathsInfo
onready var _player_node = $MapArea/PlayerNode

onready var _health_num = $CanvasLayer/PlayerInfo/Health/Label

onready var _number_popup_pool = $CanvasLayer/NumberPopupPool

onready var _map_color_bg = $MapCanvas/MapBG/MapColorBG

var _resetting = false

func _ready():
	_on_health_updated()
	_canvas.layer = 0
	
	# Initialize fast mode from save since Map is main entry point
	var save_data = SaveLoadManager.load_data()
	if save_data["fast_mode"]:
		Engine.time_scale = 2.0
	else:
		Engine.time_scale = 1.0
	
	yield(get_tree().create_timer(.3), "timeout")
	GlobalMusic.play("Main")
	
	PlayerHealth.connect("health_updated", self, "_on_health_updated")
	PlayerHealth.connect("health_lost", self, "_on_health_lost")
	PlayerHealth.connect("health_gain", self, "_on_health_gain")
	
	_map_color_bg.modulate = Color(LevelDepth.get_depth_color())

func _on_health_updated():
	_health_num.text = str(PlayerHealth.curr_hp) + "/" + str(PlayerHealth.MAX_HP)

func _on_health_lost(amount):
	_number_popup_pool.display_number_popup("-" + str(amount), Color("ff0000"), _health_num)
	
	GlobalSounds.play("Hit")
	
	_player_node.anim.play("hit")
	yield(_player_node.anim, "animation_finished")
	_player_node.anim.play("idle")

func _on_health_gain(amount):
	_number_popup_pool.display_number_popup("+" + str(amount), Color("1aff00"), _health_num)
	
	GlobalSounds.play("Heal")
	
	_player_node.anim.play("heal")
	yield(_player_node.anim, "animation_finished")
	_player_node.anim.play("idle")

func hide_map():
	self.visible = false
	_fade.hide()
	_fade.reset_fade()

func show_map():
	self.visible = true
	_fade.show()
	_fade.fade_out()
	_fade.reset_fade()
	
	# Make sure to enable buttons upon showing map
	if not _resetting:
		enable_buttons()

func enable_buttons():
	_move_btn.enable_move()
	_set_path_btn.enable_set_path()

# Reset maps and increases level depth
func reset_map():
	_resetting = true
	
	_move_btn.disable_move()
	_set_path_btn.disable_set_path()
	
	yield(get_tree().create_timer(3), "timeout")
	
	_map_fade_anim.play("ResetMap")
	
	# Wait amount of time until fade fills map area, then reset behind the scenes
	yield(get_tree().create_timer(1.1), "timeout")
	
	# Heal player
	PlayerHealth.add_health(PlayerHealth.MAX_HP * HEAL_PERCENTAGE)
	
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
	
	# Update level depth
	LevelDepth.increase_depth()
	
	# Update map color
	_map_color_bg.modulate = Color(LevelDepth.get_depth_color())
	
	# Reset buttons after anim is done
	yield(_map_fade_anim, "animation_finished")
	_move_btn.enable_move()
	_set_path_btn.enable_set_path()
	
	_resetting = false
