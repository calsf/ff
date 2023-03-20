extends Button

const START_POS = Vector2(320, 240)

onready var _map_area = get_tree().get_root().get_node("Map/MapArea")
onready var _paths = [
	load("res://map/PathOne.tscn"),
	load("res://map/PathTwo.tscn"),
	load("res://map/PathThree.tscn"),
	load("res://map/PathFour.tscn"),
	load("res://map/PathFive.tscn")
]

func _ready():
	self.connect("pressed", self, "_on_pressed")

func _on_pressed():
	randomize()
	var new_path = _paths[randi() % _paths.size()].instance()
	new_path.set_global_position(START_POS)
	
	_map_area.add_child(new_path)
