extends Node
class_name Enemy

var enemy_num : int
var max_health : int
var health : int
var block : int
var intents = []
var next_intent : EnemyDieFace
var is_dead = false

var health_scaling = 1
var offensive_scaling = 1
var defensive_scaling = 1

# Face statuses
var _dodge = false
var _reflect = false

onready var _health_label = $Health/Label
onready var _block_label = $Block/Label
onready var _block_icon = $Block/BlockIcon
onready var _intent_icon = $NextAction/EnemyDieFace/TextureRect
onready var _intent_value_label = $NextAction/EnemyDieFace/Label
onready var _intent_value_label_roll = $NextAction/EnemyDieRoll/Label
onready var _intent_anim = $IntentAnimPlayer
onready var _enemy_anim = $EnemyAnimPlayer
onready var _target_btn = $TargetButton

onready var _die_face_info = get_tree().get_root().get_node("Encounter/CanvasLayer/DieFaceInfo")

onready var _number_popup_pool = get_tree().get_root().get_node("Encounter/CanvasLayer/NumberPopupPool")

func _ready():
	_block_icon.connect("mouse_entered", self, "_on_block_icon_entered")
	_block_icon.connect("mouse_exited", self, "_on_block_icon_exited")

# Called before added to scene to set values
func init_enemy(h_s, o_s, d_s):
	health_scaling = h_s
	offensive_scaling = o_s
	defensive_scaling = d_s

func set_max_health(val):
	max_health = val * health_scaling

# Set next intent
func set_next_intent():
	next_intent = randomize_intent()
	
	_intent_icon.set_modulate(Color(1, 1, 1, 0))
	_intent_icon.texture = next_intent.icon
	var num = next_intent.num_value
	if num > 0:
		_intent_value_label.text = str(next_intent.num_value)
		
		# Additional label to set to maintain overlay
		_intent_value_label_roll.text = str(next_intent.num_value)
	else:
		_intent_value_label.text = ""
		# Additional label to set to maintain overlay
		_intent_value_label_roll.text = ""
	
	# Reset signal if needed for updated dice
	if _intent_icon.is_connected("mouse_entered", self, "_on_face_entered"):
		_intent_icon.disconnect("mouse_entered", self, "_on_face_entered")
	
	yield(_intent_anim, "animation_finished")
	
	# Set on hover for die face
	_intent_icon.connect("mouse_entered", self, "_on_face_entered", [_intent_icon, next_intent])
	
	if not _intent_icon.is_connected("mouse_exited", self, "_on_face_exited"):
		_intent_icon.connect("mouse_exited", self, "_on_face_exited")

func randomize_intent():
	randomize()
	return intents[randi() % intents.size()]

# Set by target selection
func set_enemy_num(num):
	var enemy_label = $NextAction/Label
	
	enemy_num = num
	enemy_label.text = "FACE " + str(enemy_num)

# Add block amount
func add_block(amount):
	block += amount
	_block_label.text = str(block)
	
	_number_popup_pool.display_number_popup("+" + str(amount), Color("80baff"), _block_label)

# Remove block
func remove_block(amount, combat=null):
	block -= amount
	_block_label.text = str(block)
	
	if combat != null and _reflect:
		combat.deal_blockable_player_damage(amount / 2)
	
	_number_popup_pool.display_number_popup("-" + str(amount), Color("ff0000"), _block_label)

# Add health
func add_health(amount):
	var diff = (health + amount) - max_health
	
	if diff >= 0:
		amount = amount - diff
	
	health += amount
	_health_label.text = str(health)
	
	_number_popup_pool.display_number_popup("+" + str(amount), Color("1aff00"), _health_label)

# Deal blockable damage, damages block first
func deal_blockable_damage(amount, combat):
	if amount > 0 and block > 0:
		GlobalSounds.play("Blocked")
	
	if block >= amount:
		remove_block(amount, combat)
		
		_enemy_anim.play("blocked")
		yield(_enemy_anim, "animation_finished")
		_enemy_anim.play("idle")
	
		return 0
	else:
		if block > 0:
			amount -= block
			remove_block(block, combat)
		return deal_direct_damage(amount, combat)

# Deal direct damage, subtract amount from health
func deal_direct_damage(amount, combat, undodgable=false):
	if _dodge and not undodgable:
		amount = 0
	
	health -= amount
	
	if health < 0:
		health = 0
	
	_health_label.text = str(health)
	
	_number_popup_pool.display_number_popup("-" + str(amount), Color("ff0000"), _health_label)
	
	if amount > 0:
		GlobalSounds.play("Hit")
	
	if amount > 0:
		_enemy_anim.play("damaged")
		yield(_enemy_anim, "animation_finished")
		if health > 0:
			_enemy_anim.play("idle")
	
	return amount

func set_health(value):
	health = value
	_health_label.text = str(health)

func reset_block():
	block = 0
	_block_label.text = str(block)

# Move info box to position with the corresponding die info
func _on_face_entered(face_node, face_obj):
	# Do nothing if empty face name
	if face_obj.face_name == "":
		return
	
	if is_dead:
		return
	
	var y_offset = Vector2(0, face_node.rect_size.y + 18)
	
	_die_face_info.set_face_info(face_obj)
	_die_face_info.set_global_position(face_node.get_global_position() - (face_node.rect_size / 1.5) + y_offset)
	
	_die_face_info.visible = true

# Hide info box after exiting a die face node
func _on_face_exited():
	_die_face_info.visible = false

# Play face
func play_face(combat):
	_intent_anim.play("play")
	yield(_intent_anim, "animation_finished")
	
	next_intent.on_play(combat)

# On death
func on_death():
	is_dead = true
	
	_target_btn.visible = false
	_enemy_anim.play("death")
	yield(_enemy_anim, "animation_finished")

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
	var y_offset = Vector2(0, target.rect_size.y * 2)
	
	_die_face_info.set_global_position(target.rect_global_position - Vector2((target.rect_size.x / 1.1), 0) - y_offset)
	
	_die_face_info.visible = true

# Hide die face info
func _on_block_icon_exited():
	_die_face_info.visible = false

# Statuses
func reset_statuses():
	_dodge = false
	_reflect = false
	
	update_status_icons()

func set_dodge(val):
	_dodge = val
	update_status_icons()

func set_reflect(val):
	_reflect = val
	update_status_icons()

func update_status_icons():
	if _dodge:
		_block_icon.texture = load("res://combat/dodge_icon.png")
	elif _reflect:
		_block_icon.texture = load("res://combat/reflect_icon.png")
	else:
		_block_icon.texture = load("res://combat/block_icon.png")
