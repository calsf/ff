extends Node

# Paths to each loot scene
const LOOT_DIE = "res://loot/LootDie.tscn"
const LOOT_DIE_FACE = "res://loot/LootDieFace.tscn"
const LOOT_DIE_REMOVE = "res://loot/LootDieRemove.tscn"
const LOOT_DIE_SAME_FACE = "res://loot/LootDieSameFace.tscn"
const LOOT_DIE_MULTI = "res://loot/LootDieFaceMulti.tscn"

const MAX_DROPS = 4

onready var _skip_btn = $SkipBtn
onready var _anim = $AnimationPlayer
onready var _loot = $Loot
onready var _loot_count = 0

onready var _paths_info = get_tree().get_root().get_node("Map/CanvasLayer/PathsInfo")
onready var _fade = get_tree().get_root().get_node("Encounter/CanvasLayer/Fade")

func _ready():
	_skip_btn.connect("pressed", self, "_on_skip_loot_pressed")

func activate():
	_get_drops()
	
	self.visible = true
	_anim.play("open")
	
	yield(_anim, "animation_finished")

func _on_skip_loot():
	_anim.play("close")
	
	yield(_anim, "animation_finished")
	self.visible = false
	
	# On loot skip/finish, add new path only if Combat encounter was cleared
	if get_tree().get_root().get_node("Encounter") is CombatScene:
		_paths_info.add_paths_avail()
	
	yield(get_tree().create_timer(.6), "timeout")
	_fade.go_to_scene("res://map/Map.tscn")

func _on_skip_loot_pressed():
	_on_skip_loot()
	GlobalSounds.play("ButtonPressed")

func _get_drops():
	# 1 -4 total number of loot possible
	randomize()
	_loot_count = randi() % MAX_DROPS + 1
	
	var has_replaced_die = false
	
	# Randomize each loot drop
	for i in range(_loot_count):
		randomize()
		var num = randi() % 100
		
		if num >= 0 and num < 5: # Die face multiple
			var loot_drop = load(LOOT_DIE_MULTI).instance()
			_loot.add_child(loot_drop)
		elif num >= 0 and num < 10: # Die with same faces
			# Replace die drop with die remove once per loot screen if max dice owned
			if PlayerDiceBank.get_owned_dice() >= PlayerDiceBank.MAX_OWNED_DICE and not has_replaced_die:
				var loot_drop = load(LOOT_DIE_REMOVE).instance()
				_loot.add_child(loot_drop)
				has_replaced_die = true
			else: # Normal die with same faces drop
				var loot_drop = load(LOOT_DIE_SAME_FACE).instance()
				_loot.add_child(loot_drop)
		elif num >= 10 and num < 35:	# Die
			# Replace die drop with die remove once per loot screen if max dice owned
			if PlayerDiceBank.get_owned_dice() >= PlayerDiceBank.MAX_OWNED_DICE and not has_replaced_die:
				var loot_drop = load(LOOT_DIE_REMOVE).instance()
				_loot.add_child(loot_drop)
				has_replaced_die = true
			else: # Normal die drop
				var loot_drop = load(LOOT_DIE).instance()
				_loot.add_child(loot_drop)
		elif num >= 35 and num < 90:	# Die face
			var loot_drop = load(LOOT_DIE_FACE).instance()
			_loot.add_child(loot_drop)
		elif num >= 90 and num <= 100:	# Remove die
			var loot_drop = load(LOOT_DIE_REMOVE).instance()
			_loot.add_child(loot_drop)
		else:	# Default drop
			var loot_drop = load(LOOT_DIE_FACE).instance()
			_loot.add_child(loot_drop)

func remove_loot(loot, loot_claimed=true):
	if loot_claimed:
		_loot_count -= 1
	
	loot.queue_free()
	
	if _loot_count <= 0:
		_on_skip_loot()
