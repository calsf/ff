extends Enemy
class_name MinionThirteen

var curr_intent = 0

func _ready():
	set_max_health(30)
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceBlock.new(10, self),
		EnemyFaceAttack.new(5, self),
		EnemyFaceBlockReflect.new(15, self),
		EnemyFaceAttackPerfect.new(15, self),
	]
	
	set_next_intent()

func randomize_intent():
	# Go through intents in order
	var next_intent = intents[curr_intent]
	curr_intent += 1
	
	if curr_intent > intents.size() - 1:
		curr_intent = 0
	
	return next_intent
