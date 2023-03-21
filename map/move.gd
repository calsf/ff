extends Button

onready var _move_options = get_tree().get_root().get_node("Map/MoveOptions")
onready var _set_path = get_tree().get_root().get_node("Map/CanvasLayer/SetPathBtn")

func _ready():
	self.connect("pressed", self, "_on_pressed")

func _on_pressed():
	_move_options.activate()
	
	# Disable move button
	disable_move()
	
	# Re-enable set path button and cancel set path
	_set_path.enable_set_path()
	_set_path.cancel_set_path()

func disable_move():
	self.disabled = true
	self.set_modulate(Color(.7, .7, .7, 1))

func enable_move():
	self.disabled = false
	self.set_modulate(Color(1, 1, 1, 1))

func cancel_move_options():
	_move_options.deactivate()
	
