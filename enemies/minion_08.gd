extends Enemy
class_name MinionEight

func _ready():
	set_max_health(16)
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttackCombo.new(3 * offensive_scaling, self)
	]
	
	set_next_intent()
