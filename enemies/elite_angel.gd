extends Enemy

var enrage_intents = [
	EnemyFaceDrain.new(10 * offensive_scaling, self),
	EnemyFaceHeal.new(10 * defensive_scaling, self),
]

func _ready():
	max_health = 166
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(9 * offensive_scaling, self),
		EnemyFaceBlock.new(15 * defensive_scaling, self)
	]
	
	set_next_intent()

func randomize_intent():
	# Use enrage intents once below half
	if health < (max_health / 2):
		randomize()
		return enrage_intents[randi() % enrage_intents.size()]
	
	randomize()
	return intents[randi() % intents.size()]
