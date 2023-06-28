extends Enemy

func _ready():
	max_health = 80
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttackBlock.new(7 * offensive_scaling, self),
		EnemyFaceAttack.new(10 * offensive_scaling, self),
		EnemyFaceFavorless.new(1, self),
		EnemyFaceExhaust.new(0, self),
	]
	
	set_next_intent()


