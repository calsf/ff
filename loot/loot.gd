extends Node

# Paths to each loot scene
const LOOT_DIE = "res://loot/LootDie.tscn"
const LOOT_DIE_FACE = "res://loot/LootDieFace.tscn"
const LOOT_DIE_REMOVE = "res://loot/LootDieRemove.tscn"

onready var _skip_btn = $SkipBtn
onready var _anim = $AnimationPlayer
onready var _loot = $Loot
onready var _loot_count = 0

func _ready():
	_skip_btn.connect("pressed", self, "_on_skip_loot")

func activate():
	_get_drops()
	
	self.visible = true
	_anim.play("open")
	
	yield(_anim, "animation_finished")

func _on_skip_loot():
	_anim.play("close")
	
	yield(_anim, "animation_finished")
	self.visible = false

func _get_drops():
	# 1 -4 total number of loot possible
	randomize()
	_loot_count = randi() % 4 + 1
	
	# Randomize each loot drop
	for i in range(_loot_count):
		randomize()
		var num = randi() % 100
		
		if num > 0 and num < 30:	# Die
			var loot_drop = load(LOOT_DIE).instance()
			_loot.add_child(loot_drop)
		elif num > 30 and num < 90:	# Die face
			var loot_drop = load(LOOT_DIE_FACE).instance()
			_loot.add_child(loot_drop)
		elif num > 90 and num < 100:	# Remove die
			var loot_drop = load(LOOT_DIE_REMOVE).instance()
			_loot.add_child(loot_drop)

func remove_loot(loot):
	loot.queue_free()
	_loot_count -= 1
	
	if _loot_count <= 0:
		_on_skip_loot()
