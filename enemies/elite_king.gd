extends Enemy

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(1, self),
		EnemyFaceHealAll.new(10, self),
		EnemyFaceBlockAll.new(15, self)
	]
	
	set_next_intent()
