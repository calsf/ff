extends Sprite

onready var _area = $Area2D
onready var _face = $Face

var moveable = false
var _area_entered = false

var move_sound_count = 0

signal moved(path_node)

func _ready():
	_area.connect("mouse_entered", self, "_area_entered")
	_area.connect("mouse_exited", self, "_area_exited")
	_area.connect("input_event", self, "_area_pressed")

func _process(delta):
	# When hovered over, set face modulate to be more visible
	# Also overrides flashing anim while hovered
	if _area_entered:
		_face.set_modulate(Color(1, 1, 1, .8))

func _physics_process(delta):
	check_moveable()

func check_moveable():
	var overlapping_areas = _area.get_overlapping_areas()
	
	if overlapping_areas:	# Is on top of a path node, can be moved to
		moveable = true
		self.set_modulate(Color(1, 1, 1, 1))
	else:	# Is NOT on top of a path node, can NOT be moved to
		moveable = false
		self.set_modulate(Color(1, 1, 1, 0))

func get_node_target():
	var overlapping_areas = _area.get_overlapping_areas()
	
	if overlapping_areas:
		for area in overlapping_areas:
			return area.get_parent()

func _area_entered():
	_area_entered = true

func _area_exited():
	_area_entered = false

func _area_pressed(v, event, s):
	if event is InputEventMouseButton:
		if moveable and event.button_index == BUTTON_LEFT and event.pressed and _area_entered:
			emit_signal("moved", self)
			
			# Alternate sounds
			if move_sound_count == 0:
				GlobalSounds.play("Move01")
			else:
				GlobalSounds.play("Move02")
				
			move_sound_count += 1
			if move_sound_count > 1:
				move_sound_count = 0
