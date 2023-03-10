extends Enemy

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()
	
	var attack = EnemyFaceDodge.new(5, self)
	var block = EnemyFaceAttackPerfect.new(5, self)

	intents = [
		attack,
		block
	]
	
	set_next_intent()
