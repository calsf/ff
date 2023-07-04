extends EnemyDieFace
class_name EnemyFaceDrain

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "DRAIN"
	face_info = "Deal " + str(num_value) + " damage. Heal for unblocked damage dealt."
	icon = load("res://dice/faces/face-drain.png")
	
	enemy_owner = enemy

func on_play(combat):
	var heal_amount = combat.deal_blockable_player_damage(num_value, enemy_owner)
	enemy_owner.add_health(heal_amount)
