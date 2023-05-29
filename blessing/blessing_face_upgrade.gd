extends BlessingOption
class_name BlessingFaceUpgrade

func _on_blessing_pressed(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			PlayerDiceBank.upgrade_dice_faces()
			
			_on_blessing_exited()
			blessing_container.close_blessings()
			
			GlobalSounds.play("ButtonPressed")
