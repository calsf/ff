extends Enemy

var curr_intent = 0

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(10 * offensive_scaling, self),
		EnemyFaceBlock.new(15 * defensive_scaling, self),
		EnemyFaceAttackBrutal.new(10 * offensive_scaling, self),
		EnemyFaceBlockReflect.new(10 * defensive_scaling, self),
		EnemyFaceAttackPerfect.new(10 * offensive_scaling, self)
	]
	
	set_next_intent()

func randomize_intent():
	# Go through intents in order
	var next_intent = intents[curr_intent]
	curr_intent += 1
	
	if curr_intent > intents.size() - 1:
		curr_intent = 0
	
	return next_intent
