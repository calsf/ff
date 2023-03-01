extends Control

var original_loot = null

onready var _btn_cancel = $ButtonCancel

onready var _dice_bank = get_tree().current_scene.get_node("CanvasLayer/DiceBank")
onready var _loot = get_tree().current_scene.get_node("CanvasLayer/LootScreen")

func _ready():
	_btn_cancel.connect("pressed", self, "_on_cancel")
	
	# Initialize self
	self.visible = false

func activate_selection(loot):
	self.visible = true
	
	original_loot = loot
	
	var dice = _dice_bank.get_dice_nodes()
	for die_index in range(dice.size()):
		var faces = dice[die_index].get_children()
		for face_index in range(1, faces.size()):
			faces[face_index].connect("gui_input", self, "_on_face_pressed", [die_index, face_index - 1])
	_dice_bank.connect_face_entered_exited()

# Button pressed event
func _on_cancel():
	self.visible = false
	original_loot = null
	
	var dice = _dice_bank.get_dice_nodes()
	for die_index in range(dice.size()):
		var faces = dice[die_index].get_children()
		for face_index in range(1, faces.size()):
			faces[face_index].disconnect("gui_input", self, "_on_face_pressed")
	
	_dice_bank.disconnect_face_entered_exited()

func _on_face_pressed(event, die_index, face_index):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if PlayerDiceBank.dice[die_index].is_empty:
				return
			
			PlayerDiceBank.replace_face(die_index, face_index, original_loot.loot_face)
			
			_loot.remove_loot(original_loot)
			_on_cancel()
