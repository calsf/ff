extends Enemy

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttackBrutal.new(7, self),
		EnemyFaceBlock.new(7, self)
	]
	
	set_next_intent()

func randomize_intent():
	randomize()
	var num = randi() % 100
	
	if num <= 70:
		return intents[0]
	else:
		return intents[1]
