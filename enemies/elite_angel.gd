extends Enemy

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceDrain.new(5, self),
		EnemyFaceHeal.new(10, self),
		EnemyFaceAttack.new(5, self),
		EnemyFaceBlock.new(5, self)
	]
	
	set_next_intent()
