extends Enemy
class_name MinionTen

func _ready():
	set_max_health(25)
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttackReplay.new(5, self),
		EnemyFaceAttack.new(5, self),
		EnemyFaceAttack.new(7, self),
		EnemyFaceAttack.new(10, self),
		EnemyFaceBlock.new(5, self),
		EnemyFaceBlock.new(7, self)
	]
	
	set_next_intent()
