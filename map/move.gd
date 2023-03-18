extends Button

onready var _move_options = get_tree().get_root().get_node("Map/MoveOptions")

func _ready():
	self.connect("pressed", self, "_on_pressed")

func _on_pressed():
	_move_options.activate()
