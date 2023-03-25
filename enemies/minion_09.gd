extends Enemy
class_name MinionNine

func _ready():
	set_max_health(25)
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceHealAll.new(5, self),
		EnemyFaceHeal.new(10, self)
	]
	
	set_next_intent()
