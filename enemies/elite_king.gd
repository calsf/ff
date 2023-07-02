extends Enemy

func _ready():
	max_health = 152
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(5 * offensive_scaling, self),
		EnemyFaceFavorless.new(1, self),
		EnemyFaceHealAll.new(10 * defensive_scaling, self),
		EnemyFaceBlockAll.new(15 * defensive_scaling, self)
	]
	
	set_next_intent()
