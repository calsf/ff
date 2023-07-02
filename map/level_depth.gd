# Level depth singleton
extends Node

# Max depth before looping
const MAX_DEPTH = 7

var depth = 1

var depth_color = [
	"b8fd79",
	"79fdd5",
	"00dc3c",
	"d9ff00",
	"ffffff",
	"ab0000",
	"66ab65"
]

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
	[
		EnemyData.new(load("res://enemies/Minion01.tscn"), 3.2, 1.5, 1.5)
	],
	[
		EnemyData.new(load("res://enemies/Minion02.tscn"), 2.5, 1.5, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion02.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion02.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion02.tscn"), .7, .7, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion01.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion01.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion01.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion01.tscn"), .5, .5, .5),
		EnemyData.new(load("res://enemies/Minion02.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion01.tscn"), .5, .5, .5)
	],
	[
		EnemyData.new(load("res://enemies/Minion02.tscn"), .5, .5, .5),
		EnemyData.new(load("res://enemies/Minion01.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion02.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion02.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion02.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion01.tscn"), 1.5, 1, 1),
		EnemyData.new(load("res://enemies/Minion01.tscn"), 1.5, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion01.tscn"), 1.5, 1, 1),
		EnemyData.new(load("res://enemies/Minion02.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion03.tscn"), 2, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion01.tscn"), .8, .8, .8),
		EnemyData.new(load("res://enemies/Minion03.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion01.tscn"), 1, 1, 1)
	]
]

var t2_minions = [
	[
		EnemyData.new(load("res://enemies/Minion01.tscn"), 4, 1.5, 1.5)
	],
	[
		EnemyData.new(load("res://enemies/Minion02.tscn"), 3, 1.5, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion03.tscn"), 2.5, 1.2, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion04.tscn"), 2, 1, 1.5)
	],
	[
		EnemyData.new(load("res://enemies/Minion01.tscn"), 1.2, 1.2, 1.2),
		EnemyData.new(load("res://enemies/Minion02.tscn"), 1.2, 1.2, 1.2),
		EnemyData.new(load("res://enemies/Minion03.tscn"), 1.2, 1.2, 1.2)
	],
	[
		EnemyData.new(load("res://enemies/Minion03.tscn"), 1.2, 1.2, 1.2),
		EnemyData.new(load("res://enemies/Minion03.tscn"), 1.2, 1.2, 1.2),
		EnemyData.new(load("res://enemies/Minion03.tscn"), 1.2, 1.2, 1.2)
	],
	[
		EnemyData.new(load("res://enemies/Minion01.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion04.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion01.tscn"), .7, .7, .7)
	],
	[
		EnemyData.new(load("res://enemies/Minion02.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion04.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion02.tscn"), .5, .5, .5)
	],
	[
		EnemyData.new(load("res://enemies/Minion04.tscn"), .8, .8, .8),
		EnemyData.new(load("res://enemies/Minion03.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion03.tscn"), .8, .8, .8),
		EnemyData.new(load("res://enemies/Minion04.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion01.tscn"), 1.5, 1.5, 1.5),
		EnemyData.new(load("res://enemies/Minion02.tscn"), 1.5, 1.5, 1.5)
	],
	[
		EnemyData.new(load("res://enemies/Minion04.tscn"), .8, .8, .8),
		EnemyData.new(load("res://enemies/Minion04.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion04.tscn"), .8, .8, .8)
	]
]

var t3_minions = [
	[
		EnemyData.new(load("res://enemies/Minion01.tscn"), 2.5, 1.5, 1.5),
		EnemyData.new(load("res://enemies/Minion01.tscn"), 2.5, 1.5, 1.5)
	],
	[
		EnemyData.new(load("res://enemies/Minion02.tscn"), 1.7, 1.5, 1),
		EnemyData.new(load("res://enemies/Minion02.tscn"), 1.7, 1.5, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion03.tscn"), 2.5, 1.5, 1.5)
	],
	[
		EnemyData.new(load("res://enemies/Minion04.tscn"), 2.5, 1.5, 1.5)
	],
	[
		EnemyData.new(load("res://enemies/Minion05.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion01.tscn"), 2, 2, 2),
		EnemyData.new(load("res://enemies/Minion06.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion01.tscn"), 2, 2, 2)
	],
	[
		EnemyData.new(load("res://enemies/Minion02.tscn"), 1.5, 1, 1),
		EnemyData.new(load("res://enemies/Minion06.tscn"), 1, 1, 1),
	],
	[
		EnemyData.new(load("res://enemies/Minion05.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion06.tscn"), 1, 1, 1),
	],
	[
		EnemyData.new(load("res://enemies/Minion06.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion06.tscn"), .5, 1, 1),
		EnemyData.new(load("res://enemies/Minion04.tscn"), 1.8, 1, 1),
	],
	[
		EnemyData.new(load("res://enemies/Minion03.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion05.tscn"), 1, 1, 1),
	]
]

var t4_minions = [
	[
		EnemyData.new(load("res://enemies/Minion07.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion08.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion06.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion03.tscn"), 1.5, 1.5, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion08.tscn"), 1.5, 1.5, 1.5)
	],
	[
		EnemyData.new(load("res://enemies/Minion07.tscn"), 2, 1.5, 1.5)
	],
	[
		EnemyData.new(load("res://enemies/Minion01.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion05.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion01.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion05.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion08.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion07.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion05.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion05.tscn"), .6, 1, 1),
		EnemyData.new(load("res://enemies/Minion05.tscn"), .6, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion07.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion07.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion08.tscn"), .8, 1, 1),
		EnemyData.new(load("res://enemies/Minion08.tscn"), .8, 1, 1),
		EnemyData.new(load("res://enemies/Minion06.tscn"), .5, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion01.tscn"), 1.5, 1.5, 1.5),
		EnemyData.new(load("res://enemies/Minion03.tscn"), 1.5, 1.5, 1.5),
		EnemyData.new(load("res://enemies/Minion08.tscn"), .8, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion02.tscn"), 1.2, 1.2, 1.2),
		EnemyData.new(load("res://enemies/Minion04.tscn"), 1.5, 1.5, 1.5),
		EnemyData.new(load("res://enemies/Minion06.tscn"), .6, 1, 2)
	],
	[
		EnemyData.new(load("res://enemies/Minion06.tscn"), .8, 2, 2),
		EnemyData.new(load("res://enemies/Minion06.tscn"), .8, 2, 2)
	]
]

var t5_minions = [
	[
		EnemyData.new(load("res://enemies/Minion05.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion05.tscn"), .8, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion06.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion09.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion10.tscn"), 1.5, 1.2, 1.2)
	],
	[
		EnemyData.new(load("res://enemies/Minion08.tscn"), 2, 1.5, 1.5)
	],
	[
		EnemyData.new(load("res://enemies/Minion09.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion10.tscn"), 1.5, 1.5, 1.5),
		EnemyData.new(load("res://enemies/Minion09.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion09.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion05.tscn"), 1.5, 1.5, 1.5),
		EnemyData.new(load("res://enemies/Minion09.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion09.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion10.tscn"), 1, 1, 1),
	],
	[
		EnemyData.new(load("res://enemies/Minion03.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion10.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion03.tscn"), 1, 1, 1),
	],
	[
		EnemyData.new(load("res://enemies/Minion06.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion10.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion04.tscn"), 1, 1, 1),
	],
	[
		EnemyData.new(load("res://enemies/Minion07.tscn"), 1.5, 1.5, 1.5),
		EnemyData.new(load("res://enemies/Minion10.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion02.tscn"), 3, 3, 3),
		EnemyData.new(load("res://enemies/Minion02.tscn"), 3, 3, 3)
	],
	[
		EnemyData.new(load("res://enemies/Minion10.tscn"), .7, .7, .7),
		EnemyData.new(load("res://enemies/Minion01.tscn"), 2, 2, 2),
		EnemyData.new(load("res://enemies/Minion03.tscn"), 2, 2, 2)
	],
]

var t6_minions = [
	[
		EnemyData.new(load("res://enemies/Minion11.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion12.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion01.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion12.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion09.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion12.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion07.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion05.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion12.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion09.tscn"), 2, 1.5, 1.5),
		EnemyData.new(load("res://enemies/Minion06.tscn"), 2, 1.5, 1.5),
	],
	[
		EnemyData.new(load("res://enemies/Minion11.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion05.tscn"), 1, 1, 1),
	],
	[
		EnemyData.new(load("res://enemies/Minion08.tscn"), 1.2, 1.2, 1.2),
		EnemyData.new(load("res://enemies/Minion11.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion04.tscn"), 1.2, 1.2, 1.2)
	],
	[
		EnemyData.new(load("res://enemies/Minion10.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion08.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion05.tscn"), 1, 1, 1),
	],
	[
		EnemyData.new(load("res://enemies/Minion08.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion12.tscn"), 1, 1, 1),
	],
	[
		EnemyData.new(load("res://enemies/Minion04.tscn"), 2, 2, 2),
		EnemyData.new(load("res://enemies/Minion11.tscn"), .8, .8, .8),
		EnemyData.new(load("res://enemies/Minion03.tscn"), 2, 2, 2)
	],
	[
		EnemyData.new(load("res://enemies/Minion06.tscn"), 1.5, 1.5, 1.5),
		EnemyData.new(load("res://enemies/Minion11.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion07.tscn"), 1.5, 1.5, 1.5)
	]
]

var t7_minions = [
	[
		EnemyData.new(load("res://enemies/Minion13.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion13.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion11.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion05.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion05.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion05.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion13.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion09.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion11.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion09.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion10.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion13.tscn"), .6, 1, 1),
		EnemyData.new(load("res://enemies/Minion12.tscn"), .8, .8, .8),
		EnemyData.new(load("res://enemies/Minion13.tscn"), .6, 1, 1),
	],
	[
		EnemyData.new(load("res://enemies/Minion12.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion12.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion10.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion12.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/Minion08.tscn"), 1, 2, 2),
		EnemyData.new(load("res://enemies/Minion08.tscn"), 1, 2, 2),
		EnemyData.new(load("res://enemies/Minion08.tscn"), 1, 2, 2)
	],
	[
		EnemyData.new(load("res://enemies/Minion08.tscn"), 1, 1, 2),
		EnemyData.new(load("res://enemies/Minion12.tscn"), 1, 1, 2),
		EnemyData.new(load("res://enemies/Minion08.tscn"), 1, 1, 2)
	],
	[
		EnemyData.new(load("res://enemies/Minion04.tscn"), 1, 2, 2),
		EnemyData.new(load("res://enemies/Minion09.tscn"), 1, 2, 2),
		EnemyData.new(load("res://enemies/Minion10.tscn"), 1, 2, 2)
	],
	[
		EnemyData.new(load("res://enemies/Minion11.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/Minion08.tscn"), .6, .6, .6),
		EnemyData.new(load("res://enemies/Minion13.tscn"), 1, 1, 1)
	]
]

var t1_bosses = [
	[
		EnemyData.new(load("res://enemies/EliteSamurai.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/EliteJester.tscn"), 1, 1, 1)
	]
]

var t2_bosses = [
	[
		EnemyData.new(load("res://enemies/EliteSamurai.tscn"), 1.2, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/EliteJester.tscn"), 1.18, 1, 1)
	]
]

var t3_bosses = [
	[
		EnemyData.new(load("res://enemies/EliteSlime.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/EliteCube.tscn"), 1, 1, 1)
	]
]

var t4_bosses = [
	[
		EnemyData.new(load("res://enemies/EliteSlime.tscn"), 1, 1.5, 1)
	],
	[
		EnemyData.new(load("res://enemies/EliteCube.tscn"), 1, 1.5, 1)
	]
]

var t5_bosses = [
	[
		EnemyData.new(load("res://enemies/EliteAngel.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/EliteKing.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/EliteMachine.tscn"), 1, 1, 1)
	]
]

var t6_bosses = [
	[
		EnemyData.new(load("res://enemies/EliteMachine.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/EliteKingMinion.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/EliteKing.tscn"), 1, 1, 1),
		EnemyData.new(load("res://enemies/EliteKingMinion.tscn"), 1, 1, 1)
	],
	[
		EnemyData.new(load("res://enemies/EliteMachine.tscn"), 1, 1, 1)
	]
]

var t7_bosses = [
	[
		EnemyData.new(load("res://enemies/EliteDeath.tscn"), 1, 1, 1)
	],
]

var t_minions = [
	t1_minions,
	t2_minions,
	t3_minions,
	t4_minions,
	t5_minions,
	t6_minions,
	t7_minions,
]

var t_bosses = [
	t1_bosses,
	t2_bosses,
	t3_bosses,
	t4_bosses,
	t5_bosses,
	t6_bosses,
	t7_bosses
]

func get_enemies():
	var enemies = t_minions[(depth - 1) % MAX_DEPTH]
	
	randomize()
	return enemies[randi() % enemies.size()]

func get_enemies_boss():
	var enemies = t_bosses[(depth - 1) % MAX_DEPTH]
	
	randomize()
	return enemies[randi() % enemies.size()]

func increase_depth():
	depth += 1
	emit_signal("depth_updated")

func reset_level_depth():
	depth = 1

func get_depth_color():
	return depth_color[(depth - 1) % MAX_DEPTH]
