extends Node

var favor = 2
var player_block = 0
var turn = 0
var player_finished = false
var enemy_finished = false
var enemies = []

onready var favor_num = get_tree().current_scene.get_node("CanvasLayer/Favor/FavorNum")

func _ready():
	favor_num.text = str(favor)

func add_favor(amount):
	favor += amount
	favor_num.text = str(favor)
