extends DieFace
class_name FaceChargeBlock

var status_icon = "res://combat/StatusIconChargeBlock.tscn"

func _init(value=0):
	num_value = value
	
	face_name = "CHARGED BLOCK"
	face_info = "Blocks " + str(num_value) + " incoming damage. Blocks " + str(num_value * 2) + " incoming damage next turn."
	icon = load("res://dice/faces/face-charge-block.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	combat.add_player_block(num_value)
	combat.add_extra_face(self, target, status_icon)
	yield(combat.get_tree(), "idle_frame")

func on_extra_play(combat, target):
	combat.add_player_block(num_value * 2)
	yield(combat.get_tree(), "idle_frame")
