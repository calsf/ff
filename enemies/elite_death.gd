extends Enemy

var enrage_intents = [
	EnemyFaceAttack.new(20 * offensive_scaling, self),
	EnemyFaceBlockReflect.new(15 * defensive_scaling, self),
	EnemyFaceDrain.new(15 * offensive_scaling, self),
	EnemyFaceRage.new(0, self),
	EnemyFaceAttackPerfect.new(15 * offensive_scaling, self)
]

func _ready():
	max_health = 350
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(18 * offensive_scaling, self),
		EnemyFaceDodge.new(0, self),
		EnemyFaceAttackPerfect.new(10 * offensive_scaling, self)
	]
	
	set_next_intent()

func randomize_intent():
	# Use enrage intents once below half
	if health < (max_health / 2):
		randomize()
		return enrage_intents[randi() % enrage_intents.size()]
	
	randomize()
	return intents[randi() % intents.size()]
