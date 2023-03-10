extends Enemy

var curr_intent = 0

func _ready():
	max_health = 30
	
	set_health(max_health)
	reset_block()

	intents = [
		EnemyFaceSelfDestructThree.new(0, self),
		EnemyFaceSelfDestructTwo.new(0, self),
		EnemyFaceSelfDestructOne.new(0, self),
		EnemyFaceSelfDestructFinal.new(0, self)
	]
	
	set_next_intent()

func randomize_intent():
	var next_intent = intents[curr_intent]
	curr_intent += 1
	
	if curr_intent > intents.size() - 1:
		curr_intent = 0
	
	return next_intent