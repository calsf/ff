extends Enemy
class_name MinionThree

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(5, self),
		EnemyFaceBlock.new(5, self),
		EnemyFaceAttackBlock.new(10, self)
	]
	
	set_next_intent()
