extends Enemy

func _ready():
	max_health = 55
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttackBlock.new(10 * offensive_scaling, self),
		EnemyFaceAttack.new(10 * offensive_scaling, self),
		EnemyFaceDodge.new(0, self)
	]
	
	set_next_intent()
