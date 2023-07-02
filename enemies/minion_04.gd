extends Enemy
class_name MinionFour

func _ready():
	set_max_health(14)
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(8 * offensive_scaling, self),
		EnemyFaceBlock.new(5 * defensive_scaling, self),
		EnemyFaceAttackBrutal.new(5 * offensive_scaling, self)
	]
	
	set_next_intent()
