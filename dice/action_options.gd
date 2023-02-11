extends Control

var selected_die_index = null

onready var _btn_set = $HBoxContainer/ButtonSet
onready var _btn_discard = $HBoxContainer/ButtonDiscard
onready var _btn_reroll = $HBoxContainer/ButtonReroll
onready var _btn_cancel = $HBoxContainer/ButtonCancel

onready var _dice_bar = get_tree().current_scene.get_node("CanvasLayer/DiceBar")
onready var _target_selection = get_tree().current_scene.get_node("CanvasLayer/TargetSelection")

func _ready():
	_btn_set.connect("pressed", self, "_on_set")
	_btn_discard.connect("pressed", self, "_on_discard")
	_btn_reroll.connect("pressed", self, "_on_reroll")
	_btn_cancel.connect("pressed", self, "_on_cancel")

func _on_set():
	if PlayerDiceBank.dice[selected_die_index].curr_face.require_target:
		_target_selection.activate_selection(selected_die_index)
		visible = false
	else:
		set_face()

func _on_discard():
	PlayerDiceBank.dice[selected_die_index].action_set = false
	PlayerDiceBank.dice[selected_die_index].action_discard = true
	_dice_bar.check_can_play()
	on_cancel()

func _on_reroll():
	pass

func on_cancel():
	selected_die_index = null
	visible = false
	
	# Deselect face from dice bar
	_dice_bar.deselect_face()

# Set face action to set
func set_face():
	PlayerDiceBank.dice[selected_die_index].action_set = true
	PlayerDiceBank.dice[selected_die_index].action_discard = false
	_dice_bar.check_can_play()
	on_cancel()
