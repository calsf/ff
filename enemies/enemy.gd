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
onready var _intent_anim = $IntentAnimPlayer
onready var _enemy_anim = $EnemyAnimPlayer

onready var _die_face_info = get_tree().current_scene.get_node("CanvasLayer/DieFaceInfo")

onready var _number_popup_pool = get_tree().current_scene.get_node("CanvasLayer/NumberPopupPool")

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
	
	# Reset signal if needed for updated dice
	if _intent_icon.is_connected("mouse_entered", self, "_on_face_entered"):
		_intent_icon.disconnect("mouse_entered", self, "_on_face_entered")
	
	yield(_intent_anim, "animation_finished")
	
	# Set on hover for die face
	_intent_icon.connect("mouse_entered", self, "_on_face_entered", [_intent_icon, next_intent])
	
	if not _intent_icon.is_connected("mouse_exited", self, "_on_face_exited"):
		_intent_icon.connect("mouse_exited", self, "_on_face_exited")

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
func remove_block(amount):
	block -= amount
	_block_label.text = str(block)
	
	_number_popup_pool.display_number_popup("-" + str(amount), Color("ff0000"), _block_label)

# Add health
func add_health(amount):
	health += amount
	_health_label.text = str(health)
	
	_number_popup_pool.display_number_popup("+" + str(amount), Color("1aff00"), _health_label)

# Deal blockable damage, damages block first
func deal_blockable_damage(amount):
	if block >= amount:
		remove_block(amount)
		
		_enemy_anim.play("blocked")
		yield(_enemy_anim, "animation_finished")
		_enemy_anim.play("idle")
	
		return
	else:
		if block > 0:
			amount -= block
			remove_block(block)
		deal_direct_damage(amount)

# Deal direct damage, subtract amount from health
func deal_direct_damage(amount):
	health -= amount
	_health_label.text = str(health)
	
	_number_popup_pool.display_number_popup("-" + str(amount), Color("ff0000"), _health_label)
	
	_enemy_anim.play("damaged")
	yield(_enemy_anim, "animation_finished")
	_enemy_anim.play("idle")

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
	
	var y_offset = Vector2(0, face_node.rect_size.y + 18)
	
	_die_face_info.set_face_info(face_obj)
	_die_face_info.set_global_position(face_node.get_global_position() - (face_node.rect_size / 1.5) + y_offset)
	
	_die_face_info.visible = true

# Hide info box after exiting a die face node
func _on_face_exited():
	_die_face_info.visible = false
