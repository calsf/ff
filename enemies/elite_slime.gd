extends Enemy

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttackBlock.new(7, self),
		EnemyFaceAttack.new(10, self),
		EnemyFaceFavorless.new(5, self),
		EnemyFaceExhaust.new(0, self),
	]
	
	set_next_intent()


