extends Enemy
class_name MinionSix

var attack = EnemyFaceAttack.new(5, self)

func _ready():
	max_health = 30
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceHeal.new(5, self),
		EnemyFaceBlockReflect.new(5, self)
	]
	
	set_next_intent()

func randomize_intent():
	# Attack if full health
	if health >= max_health:
		return attack
	
	randomize()
	return intents[randi() % intents.size()]
