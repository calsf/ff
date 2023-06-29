extends DieFace
class_name FaceChargeBlock

const DEFAULT_VAL = 5
const SCALING = 2

var status_icon = "res://combat/StatusIconChargeBlock.tscn"

func _init(value=DEFAULT_VAL):
	num_value = value
	
	face_name = "CHARGED BLOCK"
	update_info()
	icon = load("res://dice/faces/face-charge-block.png")
	
	require_target = false

func on_play(combat, target, parent_die=0):
	# Apply any fortify amount first
	var val = num_value + combat.get_fortify_amount()
	
	combat.add_player_block(val)
	combat.add_extra_face(self, target, status_icon)
	yield(combat.get_tree(), "idle_frame")

func on_extra_play(combat, target):
	# Apply double block first
	var val = num_value * 2
	
	# Apply any fortify amount after
	val += combat.get_fortify_amount()
	
	combat.add_player_block(val)
	yield(combat.get_tree(), "idle_frame")

func update_info():
	face_info = "Blocks " + str(num_value) + " incoming damage. Blocks " + str(num_value * 2) + " incoming damage next turn."
