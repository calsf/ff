extends Control

var original_loot = null

onready var _btn_cancel = $ButtonCancel

onready var _dice_bank = get_tree().get_root().get_node("Encounter/CanvasLayer/DiceBank")
onready var _loot = get_tree().get_root().get_node("Encounter/CanvasLayer/LootScreen")

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
			
			GlobalSounds.play("Loot")
			
			var loot_claimed = true
			
			# If is multi face drop and there is more than 1 die face, loot has not been fully claimed
			# Set to false to avoid decrementing loot count
			var multi_face_container = original_loot.multi_face_container
			if multi_face_container != null and multi_face_container.get_children().size() > 1:
				loot_claimed = false
			
			_loot.remove_loot(original_loot, loot_claimed)
			
			# Free the parent container once loot is fully claimed
			if multi_face_container != null and loot_claimed:
				multi_face_container.queue_free()
			
			_on_cancel()
