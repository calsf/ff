extends Node
class_name Enemy

var enemy_num : int
var max_health : int
var health : int
var block : int
var intents = []
var next_intent : EnemyDieFace

onready var _health_label = $Health/Label
onready var _block_label = $Block/Label
onready var _intent_icon = $NextAction/EnemyDieFace/TextureRect
onready var _intent_value_label = $NextAction/EnemyDieFace/Label
onready var _intent_value_label_roll = $NextAction/EnemyDieRoll/Label

func _ready():
	pass

# Set next intent
func set_next_intent():
	randomize()
	next_intent = intents[randi() % intents.size()]
	
	_intent_icon.texture = next_intent.icon
	_intent_value_label.text = str(next_intent.num_value)
	
	# Additional label to set to maintain overlay
	_intent_value_label_roll.text = str(next_intent.num_value)

# Set by target selection
func set_enemy_num(num):
	var enemy_label = $NextAction/Label
	
	enemy_num = num
	enemy_label.text = "FACE " + str(enemy_num)

# Add block amount
func add_block(amount):
	block += amount
	_block_label.text = str(block)

# Deal blockable damage, damages block first
func deal_blockable_damage(amount):
	if block >= amount:
		add_block(-amount)
		return
	else:
		amount -= block
		reset_block()
		deal_direct_damage(amount)

# Deal direct damage, subtract amount from health
func deal_direct_damage(amount):
	health -= amount
	_health_label.text = str(health)

func set_health(value):
	health = value
	_health_label.text = str(health)

func reset_block():
	block = 0
	_block_label.text = str(block)
