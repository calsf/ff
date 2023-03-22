extends Sprite

const EMPTY = ""

onready var _face = $Face
onready var _anim = $AnimationPlayer
onready var _timer = $Timer
onready var _area = $Area2D

onready var _fade = get_tree().get_root().get_node("Map/CanvasLayer/Fade")

var boss_face = PathFaceCombatBoss.new()

var _is_set = false
var _possible_faces_full = [
		PathFaceCombat.new(),
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
		
		# Check again after timer to avoid overwriting
		if _is_set:
			return
		
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
	
	curr_face = face
	
	_face.texture = curr_face.icon
	
	if curr_face.face_name == EMPTY:
		set_face_used()
	
	# Enable collision
	_area.monitorable = true
	_area.monitoring = true

func set_face_used():
	is_used = true

func activate_node():
	# If node already used/activated, ignore
	if is_used:
		return
	
	set_face_used()
	_anim.play("use")
	
	# Delay before going to next scene
	yield(get_tree().create_timer(.9), "timeout")

	_fade.go_to_scene(curr_face.next_scene)

func reset_node():
	_anim.play("init")
	_is_set = false
	is_used = false
