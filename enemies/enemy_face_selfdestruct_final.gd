extends EnemyDieFace
class_name EnemyFaceSelfDestructFinal

func _init(value=0, enemy=null):
	num_value = value
	
	face_name = "SELF DESTRUCT"
	face_info = "Destroy self and deal damage equal to remaining health."
	icon = load("res://dice/faces/face-enemy-selfdestruct-final.png")
	
	enemy_owner = enemy

func on_play(combat):
	var damage = enemy_owner.health
	enemy_owner.deal_direct_damage(damage, combat)
	combat.deal_blockable_player_damage(damage, enemy_owner)
