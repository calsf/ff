# Level depth singleton
extends Node

var depth = 1

signal depth_updated()

# Class to hold enemy instance/initialization data
class EnemyData:
	var enemy : Object
	var health_scaling : float
	var offensive_scaling : float
	var defensive_scaling : float
	
	func _init(e, h_s=1, o_s=1, d_s=1):
		enemy = e
		health_scaling = h_s
		offensive_scaling = o_s
		defensive_scaling = d_s
	
	func get_health_scaling():
		return health_scaling
	
	func get_offensive_scaling():
		return offensive_scaling
	
	func get_defensive_scaling():
		return defensive_scaling

var t1_minions = [
	[EnemyData.new(load("res://enemies/Minion13.tscn"), .5, .5, .5)],
	[EnemyData.new(load("res://enemies/Minion01.tscn"), 1.5, 1.5, 1.2)]
]

var t1_boss = [
	[EnemyData.new(load("res://enemies/EliteSamurai.tscn"), 1, 1, 1)]
]

func get_enemies():
	if depth <= 5:
		randomize()
		return t1_minions[randi() % t1_minions.size()]

func get_enemies_boss():
	if depth <= 5:
		randomize()
		return t1_boss[randi() % t1_boss.size()]

func increase_depth():
	depth += 1
	emit_signal("depth_updated")

func reset_level_depth():
	depth = 1
