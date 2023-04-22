extends Control

const TITLE_SCENE_PATH = "res://title/Title.tscn"

onready var _settings_btn = $SettingsBtn
onready var _settings = $Settings

onready var _quit_btn = $Settings/Options/HBoxContainer/QuitBtn
onready var _quit_confirmation = $QuitConfirmation
onready var _quit_yes_btn = $QuitConfirmation/YesBtn
onready var _quit_no_btn = $QuitConfirmation/NoBtn

onready var _fade = get_tree().get_root().get_node("Map/CanvasLayer/Fade")

func _ready():
	_settings_btn.connect("pressed", self, "_on_settings_pressed")
	_quit_btn.connect("pressed", self, "_on_quit_pressed")
	_quit_yes_btn.connect("pressed", self, "_on_quit_yes_pressed")
	_quit_no_btn.connect("pressed", self, "_on_quit_no_pressed")
	
	_quit_confirmation.visible = false

# Toggle settings visibility
func _on_settings_pressed():
	_settings.visible = !_settings.visible
	
	GlobalSounds.play("ButtonPressed")

func _on_quit_pressed():
	_quit_confirmation.visible = true
	
	GlobalSounds.play("ButtonPressed")

func _on_quit_yes_pressed():
	if get_tree().get_root().has_node("Encounter/CanvasLayer/Fade"):
		var fade = get_tree().get_root().get_node("Encounter/CanvasLayer/Fade")
		fade.color.a = 0
		fade.show()
		fade.fade_in()
	
	_fade.go_to_scene(TITLE_SCENE_PATH)
	GlobalMusic.stop_all()
	
	GlobalSounds.play("ButtonPressed")

func _on_quit_no_pressed():
	_quit_confirmation.visible = false
	
	GlobalSounds.play("ButtonPressed")
