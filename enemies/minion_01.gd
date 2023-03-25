extends Enemy
class_name MinionOne

func _ready():
	set_max_health(5)
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(5, self),
		EnemyFaceBlock.new(5, self)
	]
	
	set_next_intent()
