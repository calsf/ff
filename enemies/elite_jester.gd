extends Enemy

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceBlockReflect.new(5, self),
		EnemyFaceAttackBlock.new(5, self),
		EnemyFaceAttack.new(5, self)
	]
	
	set_next_intent()
