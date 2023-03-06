extends DieFace
class_name FaceRage

func _init(value=0):
	num_value = value
	
	face_name = "RAGE"
	face_info = "Deal damage equal to 50% of missing health to a single target."
	icon = load("res://dice/faces/face-rage.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	var num = (PlayerHealth.MAX_HP - PlayerHealth.curr_hp) / 2
	target.deal_blockable_damage(num, combat)
	yield(combat.get_tree(), "idle_frame")
