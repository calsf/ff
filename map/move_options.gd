extends Node2D

onready var _faces = $Faces
onready var _player_node = get_tree().get_root().get_node("Map/MapArea/PlayerNode")

func _ready():
	self.set_modulate(Color(1, 1, 1, 0))
	for face in _faces.get_children():
		face.connect("moved", self, "_on_moved")

# Activate move options, position at player node position
func activate():
	self.set_global_position(_player_node.get_global_position())
	self.set_modulate(Color(1, 1, 1, 1))

func _on_moved(path_node):
	# Move player to selected path node
	_player_node.set_global_position(path_node.get_global_position())
	
	# Keep moving if path node already used or is empty, else cancel and reset move options
	var curr_node = path_node.get_node_target()
	if curr_node == null or curr_node.is_used:
		self.set_modulate(Color(1, 1, 1, 0))
		self.set_global_position(_player_node.get_global_position())
		
		# Wait one physics frame so move nodes get updated for new position
		yield(get_tree(), "physics_frame")
		self.set_modulate(Color(1, 1, 1, 1))
		return
	else:
		self.set_modulate(Color(1, 1, 1, 0))
		self.set_global_position(Vector2.ZERO)
	
