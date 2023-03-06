extends DieFace
class_name FaceSacrifice

func _init(value=0):
	num_value = value
	
	face_name = "SACRIFICE"
	face_info = "Lose 50% of your current health and deal damage equal to health lost to a single target."
	icon = load("res://dice/faces/face-sacrifice.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	var num = PlayerHealth.curr_hp / 2
	combat.deal_direct_player_damage(num)
	target.deal_blockable_damage(num, combat)
	yield(combat.get_tree(), "idle_frame")

