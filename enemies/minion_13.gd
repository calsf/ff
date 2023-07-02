extends Enemy
class_name MinionThirteen

var curr_intent = 0

func _ready():
	set_max_health(35)
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceBlock.new(10 * defensive_scaling, self),
		EnemyFaceAttack.new(17 * offensive_scaling, self),
		EnemyFaceBlockReflect.new(15 * defensive_scaling, self),
		EnemyFaceAttackPerfect.new(9 * offensive_scaling, self),
	]
	
	set_next_intent()

func randomize_intent():
	# Go through intents in order
	var next_intent = intents[curr_intent]
	curr_intent += 1
	
	if curr_intent > intents.size() - 1:
		curr_intent = 0
	
	return next_intent
