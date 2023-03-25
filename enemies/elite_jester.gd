extends Enemy

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceBlockReflect.new(10, self),
		EnemyFaceAttackBlock.new(10, self),
		EnemyFaceAttack.new(10, self),
		EnemyFaceAttackBrutal.new(10, self)
	]
	
	set_next_intent()
