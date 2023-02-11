extends Node

var favor = 2
var player_block = 0
var turn = 0
var player_finished = false
var enemy_finished = false
var enemies = []

onready var favor_num = get_tree().current_scene.get_node("CanvasLayer/Favor/FavorNum")
onready var block_num = get_tree().current_scene.get_node("CanvasLayer/PlayerInfo/Block/Label")

func _ready():
	enemies = get_tree().current_scene.get_node("CanvasLayer/Enemies").get_children()
	favor_num.text = str(favor)
	reset_player_block()

func add_favor(amount):
	favor += amount
	favor_num.text = str(favor)

func add_player_block(amount):
	player_block += amount
	block_num.text = str(player_block)

func reset_player_block():
	player_block = 0
	block_num.text = str(player_block)
