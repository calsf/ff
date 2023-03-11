extends Enemy
class_name MinionFour

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(5, self),
		EnemyFaceBlock.new(5, self),
		EnemyFaceAttackBrutal.new(5, self)
	]
	
	set_next_intent()
