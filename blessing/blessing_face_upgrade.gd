extends BlessingOption
class_name BlessingFaceUpgrade

onready var _label = $Label

func _ready():
	_label.text = "Face Values +" + str(PlayerDiceBank.INCREASE_FACE_AMOUNT)

func _on_blessing_pressed(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			PlayerDiceBank.upgrade_dice_faces()
			
			_on_blessing_exited()
			blessing_container.close_blessings()
			
			GlobalSounds.play("ButtonPressed")
