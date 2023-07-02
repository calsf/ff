extends Enemy

func _ready():
	max_health = 75
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceBlockReflect.new(10 * defensive_scaling, self),
		EnemyFaceAttackBlock.new(5 * offensive_scaling, self),
		EnemyFaceAttackBlock.new(8 * offensive_scaling, self),
		EnemyFaceAttack.new(5 * offensive_scaling, self),
		EnemyFaceAttack.new(10 * offensive_scaling, self),
		EnemyFaceAttack.new(12 * offensive_scaling, self)
	]
	
	set_next_intent()
