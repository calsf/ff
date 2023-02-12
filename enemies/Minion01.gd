extends Enemy

func _ready():
	max_health = 20
	
	set_health(max_health)
	reset_block()
	
	var attack = EnemyFaceAttack.new(5, self)
	var block = EnemyFaceBlock.new(5, self)

	intents = [
		attack,
		block
	]
	
	set_next_intent()


