extends Control

onready var _label = $Label

func _ready():
	_update_display()
	
	PlayerDiceBank.connect("starting_favor_updated", self, "_update_display")

func _update_display():
	_label.text = str(PlayerDiceBank.starting_favor)
