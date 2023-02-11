extends Node

var selected_die_index = null

onready var _btn_cancel = $ButtonCancel

onready var _action_options = get_tree().current_scene.get_node("CanvasLayer/ActionOptions")
onready var _enemies = get_tree().current_scene.get_node("CanvasLayer/Enemies")

func _ready():
	_btn_cancel.connect("pressed", self, "_on_cancel")
	
	# Initialize self
	selected_die_index = null
	self.visible = false
	
	var num = 1
	for enemy in _enemies.get_children():
		# Set enemy numbers
		enemy.set_enemy_num(num)
		num += 1
		
		# Set pressed event to set target as enemy
		var btn = enemy.get_node("TargetButton")
		btn.connect("pressed", self, "on_selection", [enemy])
		btn.disabled = true

# Button pressed event
func _on_cancel():
	_cancel_selection()
	
	# Also cancel action options
	_action_options.on_cancel()

# Disable selection and reset enemy target buttons
func _cancel_selection():
	selected_die_index = null
	self.visible = false
	
	for enemy in _enemies.get_children():
		var btn = enemy.get_node("TargetButton")
		btn.disabled = true

# Activate selection, set die index, and set enemy target buttons
func activate_selection(index):
	selected_die_index = index
	self.visible = true
	
	for enemy in _enemies.get_children():
		var btn = enemy.get_node("TargetButton")
		btn.disabled = false

# Set dice face target and finalize setting action to set
func on_selection(target):
	PlayerDiceBank.dice[selected_die_index].curr_face.target = target
	_action_options.set_face()
	_cancel_selection()
