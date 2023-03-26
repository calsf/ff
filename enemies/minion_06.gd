extends Enemy
class_name MinionSix

var attack = EnemyFaceAttack.new(5, self)

func _ready():
	set_max_health(30)
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceHeal.new(5 * defensive_scaling, self),
		EnemyFaceBlockReflect.new(5 * defensive_scaling, self)
	]
	
	set_next_intent()

func randomize_intent():
	# Attack if full health
	if health >= max_health:
		return attack
	
	randomize()
	return intents[randi() % intents.size()]
