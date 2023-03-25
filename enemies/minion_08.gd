extends Enemy
class_name MinionEight

func _ready():
	set_max_health(25)
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttackCombo.new(2, self)
	]
	
	set_next_intent()
