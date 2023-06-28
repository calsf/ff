extends Enemy
class_name MinionThree

func _ready():
	set_max_health(10)
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(5 * offensive_scaling, self),
		EnemyFaceBlock.new(7 * defensive_scaling, self),
		EnemyFaceAttackBlock.new(5 * offensive_scaling, self)
	]
	
	set_next_intent()
