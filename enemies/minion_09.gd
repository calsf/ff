extends Enemy
class_name MinionNine

func _ready():
	set_max_health(18)
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceHealAll.new(6 * defensive_scaling, self),
		EnemyFaceHeal.new(10 * defensive_scaling, self)
	]
	
	set_next_intent()
