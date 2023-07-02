extends Enemy
class_name MinionNine

func _ready():
	set_max_health(22)
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceHealAll.new(7 * defensive_scaling, self),
		EnemyFaceHeal.new(12 * defensive_scaling, self)
	]
	
	set_next_intent()
