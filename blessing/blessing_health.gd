extends BlessingOption
class_name BlessingHealth

const INCREASE_AMOUNT = 10

onready var _label = $Label

func _ready():
	_label.text = "Max Health +" + str(INCREASE_AMOUNT)

func _on_blessing_pressed(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			PlayerHealth.MAX_HP += INCREASE_AMOUNT
			PlayerHealth.add_health(INCREASE_AMOUNT)
			
			_on_blessing_exited()
			blessing_container.close_blessings()
			
			GlobalSounds.play("ButtonPressed")
