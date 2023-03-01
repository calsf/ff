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
	for i in range(dice.size()):
		dice[i].connect("gui_input", self, "_on_die_pressed", [i])
	
	_dice_bank.connect_dice_entered_exited()

# Button pressed event
func _on_cancel():
	self.visible = false
	original_loot = null
	
	_dice_bank.disconnect_dice_bank()
	var dice = _dice_bank.get_dice_nodes()
	for i in range(dice.size()):
		dice[i].disconnect("gui_input", self, "_on_die_pressed")

func _on_die_pressed(event, i):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if PlayerDiceBank.dice[i].is_empty:
				return
			
			var empty_die = Die.new("res://dice/die-numbers/die-num-remove.png")
			PlayerDiceBank.replace_die(i, empty_die)
			
			_loot.remove_loot(original_loot)
			_on_cancel()
