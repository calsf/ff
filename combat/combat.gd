extends Node

var favor = PlayerDiceBank.starting_favor
var player_block = 0
var turn = 0
var enemies = []
var enemy_fled = false
var combat_ended = false
var enemy_replay = false

# Face statuses
var _dodge = false
var _replay = false
var _reflect = false
var _guardian = false
var _guardian_icon = null # To reference the instanced icon node
var _strengthen_amount = 0
var _strengthen_icon = null	# To reference the instanced icon node
var _fortify_amount = 0
var _fortify_icon =  null # To reference the instanced icon node
var _status_icons = []

onready var _status_list = get_tree().get_root().get_node("Encounter/CanvasLayer/PlayerInfo/Statuses")
onready var _icon_replay = load("res://combat/StatusIconReplay.tscn")
onready var _icon_guardian = load("res://combat/StatusIconGuardian.tscn")
onready var _icon_strengthen = load("res://combat/StatusIconStrengthen.tscn")
onready var _icon_fortify = load("res://combat/StatusIconFortify.tscn")

var extra_faces = []
var extra_faces_target = []
var _extra_faces_icons = []

onready var _favor_num = get_tree().get_root().get_node("Encounter/CanvasLayer/Favor/FavorNum")
onready var _block_num = get_tree().get_root().get_node("Encounter/CanvasLayer/PlayerInfo/Block/Label")
onready var _block_icon = get_tree().get_root().get_node("Encounter/CanvasLayer/PlayerInfo/Block/BlockIcon")
onready var _health_num = get_tree().get_root().get_node("Encounter/CanvasLayer/PlayerInfo/Health/Label")
onready var _dice_bar = get_tree().get_root().get_node("Encounter/CanvasLayer/DiceBar")
onready var _dice_bank = get_tree().get_root().get_node("Encounter/CanvasLayer/DiceBank")
onready var _loot_screen = get_tree().get_root().get_node("Encounter/CanvasLayer/LootScreen")

onready var _die_face_info = get_tree().get_root().get_node("Encounter/CanvasLayer/DieFaceInfo")

onready var _number_popup_pool = get_tree().get_root().get_node("Encounter/CanvasLayer/NumberPopupPool")

onready var _death_screen = get_tree().get_root().get_node("Encounter/CanvasLayer/DeathScreen")

onready var _fade = get_tree().get_root().get_node("Encounter/CanvasLayer/Fade")

onready var _paths_info = get_tree().get_root().get_node("Map/CanvasLayer/PathsInfo")

func _ready():
	enemies = get_tree().get_root().get_node("Encounter/CanvasLayer/Enemies").get_children()
	_favor_num.text = str(favor)
	reset_player_block()
	
	PlayerHealth.connect("health_updated", self, "_on_health_updated")
	_block_icon.connect("mouse_entered", self, "_on_block_icon_entered")
	_block_icon.connect("mouse_exited", self, "_on_block_icon_exited")
	
	_on_health_updated()

func _on_health_updated():
	_health_num.text = str(PlayerHealth.curr_hp) + "/" + str(PlayerHealth.MAX_HP)

func add_health(amount):
	var amount_added = PlayerHealth.add_health(amount)
	
	_number_popup_pool.display_number_popup("+" + str(amount_added), Color("1aff00"), _health_num)
	
	GlobalSounds.play("Heal")

# Deal blockable damage, damages block first
func deal_blockable_player_damage(amount, attacker=null):
	if player_block <= 0:
		return deal_direct_player_damage(amount)
	
	if _dodge:
		amount = 0
	
	if amount > 0 and player_block > 0:
		GlobalSounds.play("Blocked")
	
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
	
	# If guardian and hit will be fatal, use guardian
	if _guardian and amount >= PlayerHealth.curr_hp:
		_guardian = false
		_guardian_icon.queue_free()
		
		amount = 0
	
	PlayerHealth.lose_health(amount)
	
	_number_popup_pool.display_number_popup("-" + str(amount), Color("ff0000"), _health_num)
	
	if amount > 0:
		GlobalSounds.play("Hit")
	
	return amount

func add_favor(amount):
	favor += amount
	_favor_num.text = str(favor)
	
	_number_popup_pool.display_number_popup("+" + str(amount), Color("fff000"), _favor_num)
	
	GlobalSounds.play("FavorGain")

func remove_favor(amount):
	favor = max(favor - amount, 0) # Cannot go below 0 favor
	_favor_num.text = str(favor)
	
	_number_popup_pool.display_number_popup("-" + str(amount), Color("ff0000"), _favor_num)
	
	GlobalSounds.play("FavorLoss")

func add_player_block(amount):
	player_block += amount
	_block_num.text = str(player_block)
	
	_number_popup_pool.display_number_popup("+" + str(amount), Color("80baff"), _block_num)
	
	GlobalSounds.play("BlockEquip")

func remove_player_block(amount, attacker=null):
	player_block -= amount
	_block_num.text = str(player_block)
	
	if attacker != null and _reflect and not attacker.is_dead:
		attacker.deal_blockable_damage(amount / 2, self)
	
	_number_popup_pool.display_number_popup("-" + str(amount), Color("ff0000"), _block_num)

func reset_player_block():
	player_block = 0
	_block_num.text = str(player_block)

func player_turn_finished():
	yield(get_tree().create_timer(1.0), "timeout")
	
	# Check player death
	if PlayerHealth.curr_hp <= 0:
		yield(get_tree().create_timer(.5), "timeout")
		_death_screen.on_death()
		_dice_bank.reset_dice_bank()
		return
	
	yield(enemy_death_check(), "completed")
	if combat_ended:
		return
	
	# Repeat player turn
	if _replay:
		enemy_turn_finished()
		
		# Reset enemies
		for enemy in enemies:
			enemy.reset_block()
			enemy.reset_statuses()
		
		GlobalSounds.play("Replay")
		
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
		yield(get_tree().create_timer(.3), "timeout")
	
	# Check for deaths before enemy intent reset
	yield(enemy_death_check(), "completed")
	if combat_ended:
		return
	
	# Play anim to reset enemy intents
	for enemy in enemies:
		if enemy.is_dead:
			continue
		
		# Set enemy next intent
		enemy.set_next_intent()
		var anim = enemy.get_node("IntentAnimPlayer")
		anim.play("roll")
	
	enemy_turn_finished()

func enemy_turn_finished():
	reset_player_block()
	
	# Reset face statuses
	reset_statuses()
	
	turn += 1
	
	# Check player death
	if PlayerHealth.curr_hp <= 0:
		yield(get_tree().create_timer(.5), "timeout")
		_death_screen.on_death()
		_dice_bank.reset_dice_bank()
		return
	
	if enemy_replay:	# Repeat enemy turn and reset enemy_replay
		enemy_replay = false
		GlobalSounds.play("Replay")
		
		yield(get_tree().create_timer(2), "timeout")
		player_turn_finished()
		
		
	else: # Reset turn normally
		_dice_bar.reset_dice_bar()

func enemy_death_check():
	var all_dead = true
	
	for enemy in enemies:
		if (enemy_fled and not enemy.is_dead) or (not enemy.is_dead and enemy.health <= 0):
			yield(enemy.on_death(), "completed")
		
		if not enemy.is_dead:
			all_dead = false
	
	if all_dead or enemy_fled:
		_dice_bank.disconnect_dice_bank()
		_dice_bank.reset_dice_bank()
		
		yield(get_tree().create_timer(.3), "timeout")
		
		if not enemy_fled:
			yield(_loot_screen.activate(), "completed")
		
		combat_ended = true
	
	yield(get_tree().create_timer(.1), "timeout")
	if combat_ended and enemy_fled:
		if get_tree().get_root().get_node("Encounter") is CombatScene:
			_paths_info.add_paths_avail()
		yield(get_tree().create_timer(.6), "timeout")
		_fade.go_to_scene("res://map/Map.tscn")

# Statuses
func reset_statuses():
	_dodge = false
	_replay = false
	_reflect = false
	
	for icon in _status_icons:
		icon.queue_free()
	_status_icons.clear()
	
	update_player_status_icons()

func set_dodge(val):
	_dodge = val
	update_player_status_icons()
	
	if val:
		GlobalSounds.play("DodgeEquip")

func set_replay(val):
	# If already set, do not reset to avoid dupe icons
	if _replay == val:
		return
	
	_replay = val
	
	var icon = _icon_replay.instance()
	_status_list.add_child(icon)
	_status_icons.append(icon)

func set_reflect(val):
	_reflect = val
	update_player_status_icons()

func set_guardian(val):
	# If already set, do not reset to avoid dupe icons
	if _guardian == val:
		return
	
	_guardian = val
	
	_guardian_icon = _icon_guardian.instance()
	_status_list.add_child(_guardian_icon)
	# Do not add to _status_icon list, should not be cleared after turn

func add_strengthen(val):
	# Only add icon on first strengthen
	if _strengthen_amount == 0 and val > 0:
		_strengthen_icon = _icon_strengthen.instance()
		_status_list.add_child(_strengthen_icon)
		# Do not add to _status_icon list, should not be cleared after turn
	
	_strengthen_amount += val
	
	# Update strengthen amount
	_strengthen_icon.set_status_info("Add " + str(_strengthen_amount) + " damage to all damage sources for this combat.")
	_strengthen_icon.set_num_value_text(str(_strengthen_amount))

func add_fortify(val):
	# Only add icon on first fortify
	if _fortify_amount == 0 and val > 0:
		_fortify_icon = _icon_fortify.instance()
		_status_list.add_child(_fortify_icon)
		# Do not add to _status_icon list, should not be cleared after turn
	
	_fortify_amount += val
	
	# Update fortify amount
	_fortify_icon.set_status_info("Add " + str(_fortify_amount) + " block to all block sources for this combat.")
	_fortify_icon.set_num_value_text(str(_fortify_amount))

func update_player_status_icons():
	if _dodge:
		_block_icon.texture = load("res://combat/dodge_icon.png")
	elif _reflect:
		_block_icon.texture = load("res://combat/reflect_icon.png")
	else:
		_block_icon.texture = load("res://combat/block_icon.png")

func add_extra_face(face, target, status_icon=null):
	extra_faces.append(face)
	extra_faces_target.append(target)
	
	if status_icon != null:
		var icon = load(status_icon).instance()
		icon.set_info(face, target)
		_status_list.add_child(icon)
		_extra_faces_icons.append(icon)

# Use die face info to show info if block has a special status
func _on_block_icon_entered():
	if _dodge:
		var name_label = "DODGE"
		var info = "Avoids all incoming damage."
		
		_die_face_info.set_face_info_directly(name_label, info)
	elif _reflect:
		var name_label = "BLOCK REFLECT"
		var info = "Block will reflect half of damage blocked."
		
		_die_face_info.set_face_info_directly(name_label, info)
	else:
		return
	
	var target = _block_icon
	var y_offset = Vector2(0, (target.rect_size.y / 1.2) + target.rect_size.y)
	
	_die_face_info.set_global_position(target.rect_global_position - Vector2(target.rect_size.x, 0) - y_offset)
	
	_die_face_info.visible = true

# Hide die face info
func _on_block_icon_exited():
	_die_face_info.visible = false

# Clear extra faces
func clear_extra_faces():
	extra_faces.clear()
	extra_faces_target.clear()
	for icon in _extra_faces_icons:
		icon.queue_free()
	_extra_faces_icons.clear()

# For RELOAD face
func reload_dice():
	_dice_bank.reset_dice_bank()

# To apply to damage on enemies
func get_strengthen_amount():
	return _strengthen_amount

# To apply to block on block actions
func get_fortify_amount():
	return _fortify_amount

func set_enemy_replay(val):
	enemy_replay = val
	
func enemy_exhaust_face():
	_dice_bank.exhaust_dice()
