extends Enemy

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceHeal.new(5, self),
		EnemyFaceBlock.new(5, self)
	]
	
	set_next_intent()
