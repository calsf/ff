extends Node

var favor = 2
var player_block = 0
var turn = 0
var enemies = []

# Face statuses
var _dodge = false
var _replay = false
var _reflect = false

var extra_faces = []
var extra_faces_target = []

onready var _favor_num = get_tree().current_scene.get_node("CanvasLayer/Favor/FavorNum")
onready var _block_num = get_tree().current_scene.get_node("CanvasLayer/PlayerInfo/Block/Label")
onready var _block_icon = get_tree().current_scene.get_node("CanvasLayer/PlayerInfo/Block/BlockIcon")
onready var _health_num = get_tree().current_scene.get_node("CanvasLayer/PlayerInfo/Health/Label")
onready var _dice_bar = get_tree().current_scene.get_node("CanvasLayer/DiceBar")
onready var _dice_bank = get_tree().current_scene.get_node("CanvasLayer/DiceBank")
onready var _loot_screen = get_tree().current_scene.get_node("CanvasLayer/LootScreen")

onready var _number_popup_pool = get_tree().current_scene.get_node("CanvasLayer/NumberPopupPool")

func _ready():
	enemies = get_tree().current_scene.get_node("CanvasLayer/Enemies").get_children()
	_favor_num.text = str(favor)
	reset_player_block()
	
	PlayerHealth.connect("health_updated", self, "_on_health_updated")

func _on_health_updated():
	_health_num.text = str(PlayerHealth.curr_hp)

func add_health(amount):
	var amount_added = PlayerHealth.add_health(amount)
	
	_number_popup_pool.display_number_popup("+" + str(amount_added), Color("1aff00"), _health_num)

# Deal blockable damage, damages block first
func deal_blockable_player_damage(amount, attacker=null):
	if player_block <= 0:
		return deal_direct_player_damage(amount)
	
	if _dodge:
		amount = 0
	
	if player_block >= amount:
		remove_player_block(amount, attacker)
		return 0
	else:
		if player_block > 0:
			amount -= player_block
			remove_player_block(player_block, attacker)
		return deal_direct_player_damage(amount)

# Deal direct damage, subtract amount from health
func deal_direct_player_damage(amount, undodgable=false):
	if _dodge and not undodgable:
		amount = 0
	
	PlayerHealth.lose_health(amount)
	
	_number_popup_pool.display_number_popup("-" + str(amount), Color("ff0000"), _health_num)
	
	return amount

func add_favor(amount):
	favor += amount
	_favor_num.text = str(favor)
	
	_number_popup_pool.display_number_popup("+" + str(amount), Color("fff000"), _favor_num)

func remove_favor(amount):
	favor -= amount
	_favor_num.text = str(favor)
	
	_number_popup_pool.display_number_popup("-" + str(amount), Color("ff0000"), _favor_num)

func add_player_block(amount):
	player_block += amount
	_block_num.text = str(player_block)
	
	_number_popup_pool.display_number_popup("+" + str(amount), Color("80baff"), _block_num)

func remove_player_block(amount, attacker=null):
	player_block -= amount
	_block_num.text = str(player_block)
	
	if attacker != null and _reflect:
		attacker.deal_blockable_damage(amount / 2)
	
	_number_popup_pool.display_number_popup("-" + str(amount), Color("ff0000"), _block_num)

func reset_player_block():
	player_block = 0
	_block_num.text = str(player_block)

func player_turn_finished():
	yield(get_tree().create_timer(1.0), "timeout")
	
	yield(enemy_death_check(), "completed")
	
	if _replay:
		enemy_turn_finished()
		return
	
	# Reset enemies as needed before starting their turn
	for enemy in enemies:
		enemy.reset_block()
		enemy.reset_statuses()
	
	# Play each enemy die face
	for enemy in enemies:
		if enemy.is_dead:
			continue
		
		yield(enemy.play_face(self), "completed")
		
		# Set enemy next intent
		enemy.set_next_intent()
	
	# Play anim to reset enemy intents
	var anim_to_wait_for = null
	for enemy in enemies:
		if enemy.is_dead:
			continue
		
		anim_to_wait_for = enemy.get_node("IntentAnimPlayer")
		anim_to_wait_for.play("roll")
	
	# Only need to wait for one anim since they all play anim at same time
	if anim_to_wait_for != null:
		yield(anim_to_wait_for, "animation_finished")
	
	enemy_turn_finished()

func enemy_turn_finished():
	_dice_bar.reset_dice_bar()
	
	reset_player_block()
	
	# Reset face statuses
	reset_statuses()
	
	turn += 1

func enemy_death_check():
	var all_dead = true
	
	for enemy in enemies:
		if not enemy.is_dead and enemy.health <= 0:
			yield(enemy.on_death(), "completed")
		
		if not enemy.is_dead:
			all_dead = false
	
	if all_dead:
		_dice_bank.disconnect_dice_bank()
		_dice_bank.reset_dice_bank()
		
		yield(get_tree().create_timer(.3), "timeout")
		yield(_loot_screen.activate(), "completed")
	
	yield(get_tree().create_timer(.1), "timeout")

# Statuses
func reset_statuses():
	_dodge = false
	_replay = false
	_reflect = false
	
	update_player_status_icons()

func set_dodge(val):
	_dodge = val
	update_player_status_icons()

func set_replay(val):
	_replay = val
	update_player_status_icons()

func set_reflect(val):
	_reflect = val
	update_player_status_icons()

func update_player_status_icons():
	if _dodge:
		_block_icon.texture = load("res://combat/dodge_icon.png")
	elif _reflect:
		_block_icon.texture = load("res://combat/reflect_icon.png")
	else:
		_block_icon.texture = load("res://combat/block_icon.png")

# Clear extra faces
func clear_extra_faces():
	extra_faces.clear()
	extra_faces_target.clear()

# For RELOAD face
func reload_dice():
	_dice_bank.reset_dice_bank()
