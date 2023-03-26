extends Enemy
class_name MinionTen

func _ready():
	set_max_health(25)
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttackReplay.new(5 * offensive_scaling, self),
		EnemyFaceAttack.new(5 * offensive_scaling, self),
		EnemyFaceAttack.new(7 * offensive_scaling, self),
		EnemyFaceAttack.new(10 * offensive_scaling, self),
		EnemyFaceBlock.new(5 * defensive_scaling, self),
		EnemyFaceBlock.new(7 * defensive_scaling, self)
	]
	
	set_next_intent()
