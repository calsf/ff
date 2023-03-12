extends Enemy
class_name MinionSeven

var flee_intents = [
	EnemyFaceFear.new(0, self),
	EnemyFaceFlee.new(0, self)
]
var flee_intent_count = 0

func _ready():
	max_health = 6
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(5, self),
		EnemyFaceBlock.new(5, self),
	]
	
	set_next_intent()

func randomize_intent():
	# Fear then flee once below half health
	if health < (max_health / 2):
		var next_intent = flee_intents[flee_intent_count]
		flee_intent_count += 1
		return next_intent
	
	randomize()
	return intents[randi() % intents.size()]