extends CanvasLayer

const SHAKE_DECAY_RATE = 5.0
const SHAKE_RANGE = 3

onready var _random = RandomNumberGenerator.new()

var shake = 0.0

func _ready():
	PlayerHealth.connect("health_lost", self, "shake")

func shake(i):
	shake = SHAKE_RANGE
	
func _process(delta):
	shake = lerp(shake, 0, SHAKE_DECAY_RATE * delta)
	
	self.offset = _get_random_offset()

func _get_random_offset():
	if shake == 0:
		return Vector2.ZERO
	else:
		_random.randomize()
		var x = _random.randf_range(-shake, shake)
		var y = _random.randf_range(-shake, shake)
		return Vector2(x, y)
