extends Enemy

var enrage_intents = [
	EnemyFaceAttack.new(5, self),
	EnemyFaceBlockReflect.new(5, self),
	EnemyFaceDrain.new(5, self),
	EnemyFaceRage.new(5, self),
	EnemyFaceAttackPerfect.new(5, self)
]

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(5, self),
		EnemyFaceDodge.new(5, self),
		EnemyFaceAttackPerfect.new(5, self)
	]
	
	set_next_intent()

func randomize_intent():
	# Use enrage intents once below half
	if health < (max_health / 2):
		randomize()
		return enrage_intents[randi() % enrage_intents.size()]
	
	randomize()
	return intents[randi() % intents.size()]
