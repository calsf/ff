extends Enemy

func _ready():
	max_health = 6
	
	set_health(max_health)
	reset_block()
	
	var attack = EnemyFaceRage.new(5, self)
	var block = EnemyFaceDodge.new(5, self)

	intents = [
		attack,
		block
	]
	
	set_next_intent()


