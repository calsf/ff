extends DieFace
class_name FaceFavorableAttack

func _init(value=0):
	num_value = value
	
	face_name = "FAVORABLE ATTACK"
	face_info = "Spend all favor. Deal damage equal to 200% of favor spent to a single target."
	icon = load("res://dice/faces/face-favorable-attack.png")
	
	require_target = true

func on_play(combat, target, parent_die=0):
	var num = combat.favor
	combat.remove_favor(num)
	
	# Apply double damage first
	var val = num * 2
	
	# Apply any strengthen amount after
	val += combat.get_strengthen_amount()
	
	target.deal_blockable_damage(val, combat)
	yield(combat.get_tree(), "idle_frame")
