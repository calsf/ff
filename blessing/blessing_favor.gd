extends BlessingOption
class_name BlessingFavor

func _on_blessing_pressed(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			PlayerDiceBank.starting_favor += 1
			
			_on_blessing_exited()
			blessing_container.close_blessings()
