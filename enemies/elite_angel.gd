extends Enemy

var enrage_intents = [
	EnemyFaceDrain.new(5, self),
	EnemyFaceHeal.new(10, self),
]

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(5, self),
		EnemyFaceBlock.new(5, self)
	]
	
	set_next_intent()

func randomize_intent():
	# Use enrage intents once below half
	if health < (max_health / 2):
		randomize()
		return enrage_intents[randi() % enrage_intents.size()]
	
	randomize()
	return intents[randi() % intents.size()]
