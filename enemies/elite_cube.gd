extends Enemy

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttackBrutal.new(5, self),
		EnemyFaceAttack.new(5, self),
		EnemyFaceBlock.new(5, self),
		EnemyFaceBlockReflect.new(5, self)
	]
	
	set_next_intent()
