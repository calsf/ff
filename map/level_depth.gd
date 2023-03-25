# Level depth singleton
extends Node

var depth = 0

# Class to hold enemy instance/initialization data
class EnemyData:
	var enemy : Object
	var health_scaling : float
	
	func _init(e, h_s=1):
		enemy = e
		health_scaling = h_s

var t1_minions = [
	[EnemyData.new(load("res://enemies/Minion01.tscn")), EnemyData.new(load("res://enemies/Minion01.tscn"))],
	[EnemyData.new(load("res://enemies/Minion01.tscn"), 1.5)]
]

func get_enemies():
	if depth <= 2:
		randomize()
		return t1_minions[randi() % t1_minions.size()]
