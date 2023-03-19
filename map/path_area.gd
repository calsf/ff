extends Area2D

const PATH_COLL = 1
const OUTER_COLL = 2

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

var rotation_count = 0

onready var path_faces = $PathFaces
onready var _outside_area = get_parent().get_node("OutsideArea")

func _ready():
	_calc_offsets()

func _calc_offsets():
	# Get offsets from center face
	min_x_offset = 0
	max_x_offset = 0
	min_y_offset = 0
	max_y_offset = 0
	
	if rotation_count == 1: # 90
		for face in path_faces.get_children():
			max_x_offset = min(face.get_position().y, max_x_offset)
			min_x_offset = max(face.get_position().y, min_x_offset)
			max_y_offset = max(face.get_position().x, max_y_offset)
			min_y_offset = min(face.get_position().x, min_y_offset)
	elif rotation_count == 2: # 180
		for face in path_faces.get_children():
			max_x_offset = max(face.get_position().x, max_x_offset)
			min_x_offset = min(face.get_position().x, min_x_offset)
			max_y_offset = min(face.get_position().y, max_y_offset)
			min_y_offset = max(face.get_position().y, min_y_offset)
	elif rotation_count == 3: # 270
		for face in path_faces.get_children():
			max_x_offset = max(face.get_position().y, max_x_offset)
			min_x_offset = min(face.get_position().y, min_x_offset)
			max_y_offset = max(face.get_position().x, max_y_offset)
			min_y_offset = min(face.get_position().x, min_y_offset)
	else: # 0/360
		for face in path_faces.get_children():
			max_x_offset = max(face.get_position().x, max_x_offset)
			min_x_offset = min(face.get_position().x, min_x_offset)
			max_y_offset = max(face.get_position().y, max_y_offset)
			min_y_offset = min(face.get_position().y, min_y_offset)
	
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
	if is_set:
		return
	
	var mouse_pos = get_global_mouse_position()
	var x = stepify(mouse_pos.x, STEP)
	var y = stepify(mouse_pos.y, STEP)
	
	# Restrict x and y based on default min and max and the offsets
	x = clamp(x, MIN_X + (min_x_offset / 2), MAX_X - (max_x_offset / 2))
	y = clamp(y, MIN_Y + (min_y_offset / 2), MAX_Y - (max_y_offset / 2))
	
	_move_path_area(Vector2(x, y))
	
	if event is InputEventMouseButton:
		# Set
		if event.button_index == BUTTON_LEFT and event.pressed:
			if not is_overlapping_path and is_valid:
				is_set = true
				for face in path_faces.get_children():
					face.set_face()
				self.set_modulate(Color(1, 1, 1, 1))
		
		# Rotate
		if event.button_index == BUTTON_RIGHT and event.pressed:
			# Re-calc offsets for the nextrotation and set position to account for new offsets
			rotation_count += 1
			if rotation_count > 3:
				rotation_count = 0
			
			_calc_offsets()
			var updated_x = stepify(mouse_pos.x, STEP)
			var updated_y = stepify(mouse_pos.y, STEP)

			updated_x = clamp(updated_x, MIN_X + (min_x_offset / 2), MAX_X - (max_x_offset / 2))
			updated_y = clamp(updated_y, MIN_Y + (min_y_offset / 2), MAX_Y - (max_y_offset / 2))
			
			# Reset position only if re-calculated offsets updated position
			if x != updated_x or y != updated_y:
				_move_path_area(Vector2(updated_x, updated_y))
			
			# Rotate
			_rotate_path_area(90)
			
			# Maintain original children rotation
			for face in path_faces.get_children():
				face.rotate(deg2rad(-90))

# Need to move both self and outside area
func _move_path_area(pos):
	self.set_global_position(pos)
	_outside_area.set_global_position(pos)

# Need to rotate both self and outside area
func _rotate_path_area(rot_deg):
	self.rotate(deg2rad(rot_deg))
	_outside_area.rotate(deg2rad(rot_deg))
