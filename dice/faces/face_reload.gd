extends DieFace
class_name FaceReload

const DEFAULT_VAL = 0
const SCALING = 0

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "RELOAD"
	update_info()
	icon = load("res://dice/faces/face-reload.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	combat.add_favor(PlayerDiceBank.get_used_dice())
	combat.reload_dice()
	yield(combat.get_tree(), "idle_frame")

func update_info():
	face_info = "Reload dice bank and gain 1 favor for each die reloaded."
