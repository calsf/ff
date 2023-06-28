extends Enemy
class_name MinionTwo

func _ready():
	set_max_health(7)
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(5 * offensive_scaling, self),
		EnemyFaceAttack.new(7 * offensive_scaling, self)
	]
	
	set_next_intent()
