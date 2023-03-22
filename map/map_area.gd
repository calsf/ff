extends Node2D

const START_FACE_COUNT = 3

onready var _path_start = $PathStart
onready var _player = $PlayerNode

func _ready():
	initialize_start()

func initialize_start():
	_player.set_global_position(_path_start.get_global_position())
	
	var combat = PathFaceCombat.new()
	var empty = PathFaceEmpty.new()
	var path_faces = _path_start.get_path_faces()
	
	# Remove first node and set to empty, player will start here
	var start_face = path_faces.pop_front()
	start_face.set_face_to(empty)
	
	# Set START_FACE_COUNT combat faces at random spots on the start path
	randomize()
	path_faces.shuffle()
	
	var set_count = 0
	for face in path_faces:
		# Reset node
		face.reset_node()
		
		if set_count < START_FACE_COUNT:
			face.set_face_to(combat)
			set_count += 1
		else:
			face.set_face_to(empty)

