extends Control

const TITLE_SCENE_PATH = "res://title/Title.tscn"

onready var _depth_label = $DepthInfo/Label
onready var _return_btn = $ReturnBtn
onready var _anim = $AnimationPlayer

onready var _fade = get_tree().get_root().get_node("Encounter/CanvasLayer/Fade")

func _ready():
	_return_btn.connect("pressed", self, "_on_return_pressed")
	self.visible = false
	self.set_modulate(Color(1, 1, 1, 0))

func on_death():
	_depth_label.text = str(LevelDepth.depth)
	self.visible = true
	_anim.play("fade_in")
	
	SaveLoadManager.save_run()
	
	GlobalMusic.stop_all()
	GlobalMusic.play("Death")

func _on_return_pressed():
	_fade.go_to_scene(TITLE_SCENE_PATH)
	GlobalMusic.stop_all()
