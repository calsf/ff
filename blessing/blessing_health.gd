extends BlessingOption
class_name BlessingHealth

func _on_blessing_pressed(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			PlayerHealth.MAX_HP += 1
			PlayerHealth.add_health(1)
			
			_on_blessing_exited()
			blessing_container.close_blessings()
			
			GlobalSounds.play("ButtonPressed")
