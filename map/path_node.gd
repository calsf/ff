extends Sprite

const EMPTY = ""

onready var _face = $Face
onready var _anim = $AnimationPlayer
onready var _timer = $Timer
onready var _area = $Area2D

var _is_set = false
var _possible_faces_full = [
		PathFaceCombat.new(),
		PathFaceCombatBoss.new(),
		PathFaceChest.new(),
		PathFaceBlessing.new(),
		PathFaceHazard.new(),
		PathFaceRandom.new(),
		PathFaceEmpty.new()
	]
var _possible_faces = [] # Copy of faces to flash random faces while unset
var curr_face = null
var is_used = false

func _ready():
	randomize()
	_possible_faces = _possible_faces_full.duplicate()
	_possible_faces.shuffle()
	
	# Disable collision with face node until is set
	_area.monitorable = false
	_area.monitoring = false

func _process(delta):
	# While not set, flash random face
	if not _is_set:
		yield(_timer, "timeout")
		
		# If faces are empty, duplicate and re-shuffle
		if _possible_faces.empty():
			randomize()
			_possible_faces = _possible_faces_full.duplicate()
			_possible_faces.shuffle()
		
		var face = _possible_faces.pop_front()
		_face.texture = face.icon

func set_face():
	_is_set = true
	
	randomize()
	curr_face = _possible_faces_full[randi() % _possible_faces_full.size()]
	
	_face.texture = curr_face.icon
	
	if curr_face.face_name == EMPTY:
		set_face_used()
	
	# Enable collision
	_area.monitorable = true
	_area.monitoring = true

func set_face_to(face):
	_is_set = true
	
	_face.texture = face.icon
	
	if face.face_name == EMPTY:
		set_face_used()
	
	# Enable collision
	_area.monitorable = true
	_area.monitoring = true

func set_face_used():
	is_used = true
