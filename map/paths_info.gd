extends Control

const MAX_BOSS_PATH_NUM = 7
const MIN_BOSS_PATH_NUM = 5
var _boss_path_num = MIN_BOSS_PATH_NUM

onready var _paths_label = $Paths/Label
onready var _paths = $Paths

onready var _map_area = get_tree().get_root().get_node("Map/MapArea")
onready var _die_face_info = get_tree().get_root().get_node("Map/CanvasLayer/DieFaceInfo")

onready var _possible_paths = [
	load("res://map/PathOne.tscn"),
	load("res://map/PathTwo.tscn"),
	load("res://map/PathThree.tscn"),
	load("res://map/PathFour.tscn"),
	load("res://map/PathFive.tscn")
]

var _random = RandomNumberGenerator.new()

var _paths_avail = []
var _paths_used = 0

func _ready():
	update_paths_label()
	_paths.connect("mouse_entered", self, "_on_paths_entered")
	_paths.connect("mouse_exited", self, "_on_paths_exited")
	
	# Determine what path will be the boss path
	_random.randomize()
	_boss_path_num = _random.randi_range(MAX_BOSS_PATH_NUM, MIN_BOSS_PATH_NUM)
	
	# TEMP
	print_debug(_boss_path_num)
	add_paths_avail()
	add_paths_avail()
	add_paths_avail()
	add_paths_avail()
	add_paths_avail()
	add_paths_avail()
	add_paths_avail()

func add_paths_avail():
	randomize()
	var new_path = _possible_paths[randi() % _possible_paths.size()].instance()
	
	_paths_avail.append(new_path)
	_map_area.add_child(new_path)
		
	update_paths_label()

func remove_paths_avail():
	var path = _paths_avail.pop_back()
	update_paths_label()
	
	_paths_used += 1

func get_next_path_avail():
	return _paths_avail.back()

func get_paths_avail():
	return _paths_avail

# Once paths used is one below boss path num, next path should be boss path
func next_is_boss():
	return (_paths_used + 1) == _boss_path_num

func update_paths_label():
	_paths_label.text = str(_paths_avail.size()) + "x"

func _on_paths_entered():
	var y_offset = Vector2(0, _paths.rect_size.y + 42)
	
	_die_face_info.set_face_info_directly("PATHS AVAILABLE", "Clear combat encounters to find more paths.")
	_die_face_info.set_global_position(_paths.get_global_position() - (_paths.rect_size / 1.05) - y_offset)
	
	_die_face_info.visible = true

func _on_paths_exited():
	_die_face_info.visible = false
