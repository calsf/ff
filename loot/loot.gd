extends Node

onready var _skip_btn = $SkipBtn
onready var _anim = $AnimationPlayer
onready var _loot = $Loot
onready var _loot_count = 0

func _ready():
	_skip_btn.connect("pressed", self, "_on_skip_loot")
	_loot_count = _loot.get_child_count()

func activate():
	self.visible = true
	_anim.play("open")
	
	yield(_anim, "animation_finished")

func _on_skip_loot():
	_anim.play("close")
	
	yield(_anim, "animation_finished")
	self.visible = false

func remove_loot(loot):
	loot.queue_free()
	_loot_count -= 1
	
	if _loot_count <= 0:
		_on_skip_loot()
