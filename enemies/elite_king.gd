extends Enemy

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(1, self),
		EnemyFaceHealAll.new(5, self),
		EnemyFaceBlockAll.new(5, self)
	]
	
	set_next_intent()
