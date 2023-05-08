extends Node2D

onready var _loot_screen = get_tree().get_root().get_node("Encounter/CanvasLayer/LootScreen")

func _ready():
	yield(get_tree().create_timer(0.4), "timeout")
	_loot_screen.activate()
