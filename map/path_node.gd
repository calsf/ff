extends Sprite

const EMPTY = ""

onready var _face = $Face
onready var _anim = $AnimationPlayer
onready var _timer = $Timer
onready var _area = $Area2D

onready var _fade = get_tree().get_root().get_node("Map/CanvasLayer/Fade")
onready var _map = get_tree().get_root().get_node("Map")

var boss_face = PathFaceCombatBoss.new()
var combat_face = PathFaceCombat.new()

var _is_set = false
var _possible_faces_full = [
		PathFaceCombat.new(),
		PathFaceChest.new(),
		PathFaceBlessing.new(),
		PathFaceHazard.new(),
		PathFaceRest.new(),
		PathFaceRandom.new(),
		PathFaceEmpty.new()
	]
var _possible_faces = [] # Copy of faces to flash random faces while unset

var _common_faces = [
	PathFaceCombat.new(),
	PathFaceEmpty.new()
]

var _uncommon_faces = [
	PathFaceHazard.new(),
	PathFaceRest.new(),
	PathFaceRandom.new()
]

var _rare_faces = [
	PathFaceBlessing.new(),
	PathFaceChest.new()
]

# For selecting a random face to PathFaceRandom
var _random_face_pool = [
	PathFaceCombat.new(),
	PathFaceChest.new(),
	PathFaceBlessing.new(),
	PathFaceHazard.new(),
	PathFaceRest.new()
]

var _face_pools = [
	_common_faces,
	_uncommon_faces,
	_rare_faces
]

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
	
	# Randomize for face pool
	randomize()
	var num = randi() % 100
	
	var face_pool_num = 0
	if num > 0 and num < 70:	# Common
		face_pool_num = 0
	elif num > 70 and num < 90:	# Uncommon
		face_pool_num = 1
	elif num > 90 and num < 100: # Rare
		face_pool_num = 2
	
	# Randomize selection from face pool
	randomize()
	var selected_pool = _face_pools[face_pool_num]
	curr_face = selected_pool[randi() % selected_pool.size()]
	
	_face.texture = curr_face.icon
	
	# If random, select a random face (texture will remain random path face)
	if curr_face is PathFaceRandom:
		randomize()
		curr_face = _random_face_pool[randi() % _random_face_pool.size()]
	
	if curr_face.face_name == EMPTY:
		set_face_used()
	
	# Enable collision
	_area.monitorable = true
	_area.monitoring = true

# Set face explicitly to provided face arg
# Should only be used when initializing path node since it may unset face used
func set_face_to(face):
	_is_set = true
	
	curr_face = face
	
	_face.texture = curr_face.icon
	
	if curr_face.face_name == EMPTY:
		set_face_used()
	else:
		# Face may have been set to used before, unsets face used
		unset_face_used()
	
	# Enable collision
	_area.monitorable = true
	_area.monitoring = true

func set_face_used():
	is_used = true

func unset_face_used():
	is_used = false

func activate_node():
	# If node already used/activated, ignore
	if is_used:
		return false
	
	set_face_used()
	_anim.play("use")
	
	GlobalSounds.play("Encounter")
	
	if curr_face.no_transition:
		curr_face.activate()
		return
	
	# Delay before going to next scene
	yield(get_tree().create_timer(.9), "timeout")

	_fade.go_to_scene(curr_face.next_scene)

func has_no_transition():
	return curr_face.no_transition

func reset_node():
	_anim.play("init")
	_is_set = false
	is_used = false
