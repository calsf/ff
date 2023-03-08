extends Enemy

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(5, self),
		EnemyFaceDodge.new(5, self),
		EnemyFaceDrain.new(5, self),
		EnemyFaceRage.new(5, self)
	]
	
	set_next_intent()
