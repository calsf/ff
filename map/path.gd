extends Area2D

enum {EMPTY, PATH_COLL, OUTER_COLL}

const STEP = 20
const MIN_X = 20
const MAX_X = 620
const MIN_Y = 120
const MAX_Y = 340

var min_x_offset = 0
var max_x_offset = 0
var min_y_offset = 0
var max_y_offset = 0

var is_set = false
var is_overlapping_path = false
var is_valid = false

onready var _path_faces = $PathFaces

func _ready():
	# Get offsets from center face
	min_x_offset = 0
	max_x_offset = 0
	min_y_offset = 0
	max_y_offset = 0
	for face in _path_faces.get_children():
		max_x_offset = max(face.get_position().x, max_x_offset)
		min_x_offset = min(face.get_position().x, min_x_offset)
		min_y_offset = max(face.get_position().y, min_y_offset)
		max_y_offset = max(face.get_position().y, max_y_offset)
	
	min_x_offset = abs(min_x_offset)
	max_x_offset = abs(max_x_offset)
	min_y_offset = abs(min_y_offset)
	max_y_offset = abs(max_y_offset)

func _physics_process(delta):
	if is_set:
		return
	
	var overlapping_areas = get_overlapping_areas()
	
	is_overlapping_path = false
	is_valid = false
	
	if overlapping_areas:
		for area in overlapping_areas:
			if area.get_collision_layer() == PATH_COLL:
				is_overlapping_path = true
			
			if area.get_collision_layer() == OUTER_COLL:
				is_valid = true
		
		if not is_overlapping_path and is_valid:
			self.set_modulate(Color(0, 1, 0, 1))
		else:
			self.set_modulate(Color(1, 0, 0, 1))
	else:
		self.set_modulate(Color(1, 1, 1, 1))

func _unhandled_input(event):
	# TEMP!!!
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print_debug("TESTING: GOING TO COMBAT SCENE")
			var _fade = get_tree().get_root().get_node("Map/CanvasLayer/Fade")
			_fade.go_to_scene("res://Combat.tscn")
	
	if is_set:
		return
	
	var mouse_pos = get_global_mouse_position()
	var x = stepify(mouse_pos.x, STEP)
	var y = stepify(mouse_pos.y, STEP)
	
	# Restrict x and y based on default min and max and the offsets
	x = clamp(x, MIN_X + (min_x_offset / 2), MAX_X - (max_x_offset / 2))
	y = clamp(y, MIN_Y + (min_y_offset / 2), MAX_Y - (max_y_offset / 2))
	
	self.position = Vector2(x, y)
	
	if event is InputEventMouseButton:
		# Set
		if event.button_index == BUTTON_LEFT and event.pressed:
			if not is_overlapping_path and is_valid:
				is_set = true
				self.set_modulate(Color(1, 1, 1, 1))
		
		# Rotate
		if event.button_index == BUTTON_RIGHT and event.pressed:
			self.rotate(deg2rad(90))
			
			# Maintain original children rotation
			for face in _path_faces.get_children():
				face.rotate(deg2rad(-90))
		
