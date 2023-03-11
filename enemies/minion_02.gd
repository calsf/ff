extends Enemy
class_name MinionTwo

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(5, self),
		EnemyFaceAttack.new(7, self)
	]
	
	set_next_intent()
