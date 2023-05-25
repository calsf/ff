extends HBoxContainer

onready var _anim = $AnimationPlayer

onready var _skip_btn = get_tree().get_root().get_node("Encounter/CanvasLayer/SkipBtn")
onready var _select_label = get_tree().get_root().get_node("Encounter/CanvasLayer/SelectLabel")
onready var _fade = get_tree().get_root().get_node("Encounter/CanvasLayer/Fade")

func _ready():
	_select_label.visible = false
	_skip_btn.disabled = true
	_skip_btn.set_modulate(Color(.7, .7, .7, 1))
	
	yield(_anim, "animation_finished")
	_select_label.visible = true
	_skip_btn.disabled = false
	_skip_btn.set_modulate(Color(1, 1, 1, 1))
	
	_skip_btn.connect("pressed", self, "close_blessings")

func close_blessings():
	for blessing in self.get_children():
		if blessing is BlessingOption:
			blessing.mouse_filter = MOUSE_FILTER_IGNORE
	
	_anim.play("close")
	_skip_btn.disabled = true
	_skip_btn.set_modulate(Color(.7, .7, .7, 1))
	_select_label.visible = false
	
	yield(get_tree().create_timer(.6), "timeout")
	_fade.go_to_scene("res://map/Map.tscn")
