extends Button

const START_POS = Vector2(320, 240)

onready var _move = get_tree().get_root().get_node("Map/CanvasLayer/MoveBtn")
onready var _paths_info = get_tree().get_root().get_node("Map/CanvasLayer/PathsInfo")

var next_path = null

func _ready():
	self.connect("pressed", self, "_on_pressed")

func _on_pressed():
	if _paths_info.get_paths_avail().size() <= 0:
		return
	
	# Next path should not be cleared until it gets set
	if next_path == null:
		next_path = _paths_info.get_next_path_avail()
	
	# Check if next path should be boss path
	if _paths_info.next_is_boss():
		next_path.set_as_boss_path()
	
	# Enable next path
	next_path.enable_path()
	
	# Disable set path button
	disable_set_path()
	
	# Re-enable move button and cancel move options
	_move.enable_move()
	_move.cancel_move_options()
	
	GlobalSounds.play("ButtonPressed")

# Remove the path from path info's pool and reset next_path
func _use_path():
	_paths_info.remove_paths_avail()
	next_path = null

func disable_set_path():
	self.disabled = true
	self.set_modulate(Color(.7, .7, .7, 1))

func enable_set_path():
	# Do not enable set path if no paths left
	if _paths_info.get_paths_avail().size() <= 0:
		return
	
	self.disabled = false
	self.set_modulate(Color(1, 1, 1, 1))

func cancel_set_path():
	if next_path == null:
		return
	
	# Disable the next path node
	next_path.disable_path()

func finished_set_path():
	# Path has been used
	_use_path()
	
	# Re-enable move always
	_move.enable_move()
	
	enable_set_path()
