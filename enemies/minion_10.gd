extends Enemy
class_name MinionTen

func _ready():
	set_max_health(20)
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttackReplay.new(3 * offensive_scaling, self),
		EnemyFaceAttack.new(6 * offensive_scaling, self),
		EnemyFaceAttack.new(9 * offensive_scaling, self),
		EnemyFaceAttack.new(12 * offensive_scaling, self),
		EnemyFaceBlock.new(7 * defensive_scaling, self),
		EnemyFaceBlock.new(10 * defensive_scaling, self)
	]
	
	set_next_intent()
