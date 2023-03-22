extends Sprite

onready var _area = $Area2D

func _physics_process(delta):
	var overlapping_areas = _area.get_overlapping_areas()
	
	if overlapping_areas:
		for area in overlapping_areas:
			area.get_parent().activate_node()
			return
