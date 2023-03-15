extends Sprite

onready var _area = $Area2D

func _physics_process(delta):
	var overlapping_areas = _area.get_overlapping_areas()
	
	if overlapping_areas:
		for area in overlapping_areas:
			# TODO: Detect face node
			print_debug(area.get_collision_layer())
