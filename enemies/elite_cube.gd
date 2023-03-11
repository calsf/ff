extends Enemy

var curr_intent = 0

func _ready():
	max_health = 5
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceAttack.new(5, self),
		EnemyFaceBlock.new(5, self),
		EnemyFaceAttackBrutal.new(5, self),
		EnemyFaceBlockReflect.new(5, self),
	]
	
	set_next_intent()

func randomize_intent():
	# Go through intents in order
	var next_intent = intents[curr_intent]
	curr_intent += 1
	
	if curr_intent > intents.size() - 1:
		curr_intent = 0
	
	return next_intent
