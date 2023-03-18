extends Node2D

onready var _faces = $Faces
onready var _player_node = get_tree().get_root().get_node("Map/MapArea/PlayerNode")

func _ready():
	self.set_modulate(Color(1, 1, 1, 0))
	for face in _faces.get_children():
		face.connect("moved", self, "_on_moved")

# Activate move options, position at player node position
func activate():
	self.set_modulate(Color(1, 1, 1, 1))
	self.set_global_position(_player_node.get_global_position())

func _on_moved(path_node):
	# Move player to selected path node and reset move options
	_player_node.set_global_position(path_node.get_global_position())
	
	self.set_modulate(Color(1, 1, 1, 0))
	self.set_global_position(Vector2.ZERO)
	
