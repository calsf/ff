extends Node

var favor = 2
var player_block = 0
var turn = 0
var enemies = []

onready var _favor_num = get_tree().current_scene.get_node("CanvasLayer/Favor/FavorNum")
onready var _block_num = get_tree().current_scene.get_node("CanvasLayer/PlayerInfo/Block/Label")
onready var _health_num = get_tree().current_scene.get_node("CanvasLayer/PlayerInfo/Health/Label")
onready var _dice_bar = get_tree().current_scene.get_node("CanvasLayer/DiceBar")

func _ready():
	enemies = get_tree().current_scene.get_node("CanvasLayer/Enemies").get_children()
	_favor_num.text = str(favor)
	reset_player_block()
	
	PlayerHealth.connect("health_updated", self, "_on_health_updated")

func _on_health_updated():
	_health_num.text = str(PlayerHealth.curr_hp)

# Deal blockable damage, damages block first
func deal_blockable_player_damage(amount):
	if player_block >= amount:
		add_player_block(-amount)
		return
	else:
		amount -= player_block
		reset_player_block()
		deal_direct_player_damage(amount)

# Deal direct damage, subtract amount from health
func deal_direct_player_damage(amount):
	PlayerHealth.lose_health(amount)

func add_favor(amount):
	favor += amount
	_favor_num.text = str(favor)

func add_player_block(amount):
	player_block += amount
	_block_num.text = str(player_block)

func reset_player_block():
	player_block = 0
	_block_num.text = str(player_block)

func player_turn_finished():
	# Reset enemies as needed before starting their turn
	for enemy in enemies:
		enemy.reset_block()
	
	# Play each enemy die face
	for enemy in enemies:
		var anim = enemy.get_node("EnemyAnimPlayer")
		anim.play("play")
		yield(anim, "animation_finished")
		
		enemy.next_intent.on_play(self)
		
		# Set enemy next intent
		enemy.set_next_intent()
	
	# Play anim to reset enemy intents
	var anim_to_wait_for = null
	for enemy in enemies:
		anim_to_wait_for = enemy.get_node("EnemyAnimPlayer")
		anim_to_wait_for.play("roll")
	
	yield(anim_to_wait_for, "animation_finished")
	
	enemy_turn_finished()

func enemy_turn_finished():
	_dice_bar.reset_dice_bar()
	
	reset_player_block()
	
	turn += 1
