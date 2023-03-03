extends DieFace
class_name FaceReload

func _init(value=0):
	num_value = value
	
	face_name = "RELOAD"
	face_info = "Reload dice bank and gain 1 favor for each die reloaded."
	icon = load("res://dice/faces/face-reload.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	combat.add_favor(PlayerDiceBank.get_used_dice())
	combat.reload_dice()
	yield(combat.get_tree(), "idle_frame")

