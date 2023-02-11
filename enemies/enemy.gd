extends Node
class_name Enemy

var enemy_num : int
var health : String
var block : String
var intents = []

onready var health_label = $Health/Label
onready var block_label = $Block/Label
onready var intent_value_label = $NextAction/HBoxContainer/Label

func _ready():
	pass

# Set by target selection
func set_enemy_num(num):
	var enemy_label = $NextAction/Label
	
	enemy_num = num
	enemy_label.text = "FACE " + str(enemy_num)
