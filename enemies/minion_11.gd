extends Enemy
class_name MinionEleven

func _ready():
	set_max_health(14)
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceExhaust.new(0, self),
		EnemyFaceFavorless.new(1, self),
		EnemyFaceFavorless.new(2, self)
	]
	
	set_next_intent()
