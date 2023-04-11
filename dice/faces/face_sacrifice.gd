extends DieFace
class_name FaceSacrifice

func _init(value=0):
	num_value = value
	
	face_name = "SACRIFICE"
	face_info = "Spend 50% of current health. Deal damage equal to health lost to a single target."
	icon = load("res://dice/faces/face-sacrifice.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	var num = PlayerHealth.curr_hp / 2
	
	# Apply any strengthen amount after
	var val = num + combat.get_strengthen_amount()
	
	combat.deal_direct_player_damage(num) # Do not apply strengthen amount to self dmg
	target.deal_blockable_damage(val, combat)
	yield(combat.get_tree(), "idle_frame")

