extends Sprite

onready var _area = $Area2D

onready var _move_btn = get_tree().get_root().get_node("Map/CanvasLayer/MoveBtn")
onready var _set_path_btn = get_tree().get_root().get_node("Map/CanvasLayer/SetPathBtn")

func _physics_process(delta):
	var overlapping_areas = _area.get_overlapping_areas()
	
	if overlapping_areas:
		for area in overlapping_areas:
			var activated = area.get_parent().activate_node()
			
			if not activated:
				return
			
			_move_btn.disable_move()
			_set_path_btn.disable_set_path()
			
			# Cancel any actions
			_move_btn.cancel_move_options()
			_set_path_btn.cancel_set_path()
			return
