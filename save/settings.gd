extends Control

onready var _fast_mode_btn = $Options/HBoxContainer/FastModeBtn
onready var _sound_btn = $Options/HBoxContainer/SoundBtn
onready var _music_btn = $Options/HBoxContainer/MusicBtn
onready var _back_btn = $Options/HBoxContainer/BackBtn

func _ready():
	# Set toggle buttons from save
	var save_data = SaveLoadManager.load_data()
	_fast_mode_btn.set_pressed(save_data["fast_mode"])
	_sound_btn.set_pressed(save_data["sounds_on"])
	_music_btn.set_pressed(save_data["music_on"])
	
	# Set toggle button labels based on toggle state
	_set_toggled_label(_fast_mode_btn, _fast_mode_btn.is_pressed(), "Fast Mode")
	_set_toggled_label(_sound_btn, _sound_btn.is_pressed(), "Sounds")
	_set_toggled_label(_music_btn, _music_btn.is_pressed(), "Music")
	
	_fast_mode_btn.connect("pressed", self, "_on_fast_mode_toggled")
	_sound_btn.connect("pressed", self, "_on_sound_toggled")
	_music_btn.connect("pressed", self, "_on_music_toggled")
	_back_btn.connect("pressed", self, "_on_back_pressed")
	
	self.visible = false

func _on_fast_mode_toggled():
	var save_data = SaveLoadManager.load_data()
	save_data["fast_mode"] = _fast_mode_btn.is_pressed()
	SaveLoadManager.save_data(save_data)
	
	_set_toggled_label(_fast_mode_btn, _fast_mode_btn.is_pressed(), "Fast Mode")
	
	# Also update time scale
	if _fast_mode_btn.is_pressed():
		Engine.time_scale = 2.0
	else:
		Engine.time_scale = 1.0
		
	GlobalSounds.play("ButtonPressed")

func _on_sound_toggled():
	var save_data = SaveLoadManager.load_data()
	save_data["sounds_on"] = _sound_btn.is_pressed()
	SaveLoadManager.save_data(save_data)
	
	_set_toggled_label(_sound_btn, _sound_btn.is_pressed(), "Sounds")
	
	GlobalSounds.play("ButtonPressed")

func _on_music_toggled():
	var save_data = SaveLoadManager.load_data()
	save_data["music_on"] = _music_btn.is_pressed()
	SaveLoadManager.save_data(save_data)
	
	_set_toggled_label(_music_btn, _music_btn.is_pressed(), "Music")
	
	# Also update music player volumes when music button is toggled
	GlobalMusic.update_player_volumes(_music_btn.is_pressed())
	
	GlobalSounds.play("ButtonPressed")

func _on_back_pressed():
	self.visible = false
	
	GlobalSounds.play("ButtonPressed")

# Set a button's text based on base label + toggle state
func _set_toggled_label(button, toggled, base_label):
	var toggled_label = ""
	if toggled:
		toggled_label = "ON"
	else:
		toggled_label = "OFF"
	
	button.text = base_label + " " + toggled_label
