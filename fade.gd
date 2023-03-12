extends ColorRect

# Number of nodes that should persist in root tree
# Includes autoloaded nodes
# Should free all objects after (free root_nodes[PERSISTENT_NODES + 1] and onwards)
const PERSISTENT_NODES = 3
const MAP_SCENE_NAME = "Map"
const MAP_SCENE_PATH = "res://map/Map.tscn"

signal fade_in_finished
signal fade_out_finished

var _in_transition = false
var _next_scene = ""
var _map_persisted = false

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS	# This will never pause

# Sets next scene to go to and play fade in animation
func go_to_scene(scene_name):
	if not _in_transition:
		_in_transition = true
		_next_scene = scene_name
		color.a = 0
		show()
		fade_in()

func fade_in():
	$AnimationPlayer.play("FadeIn")

func fade_out():
	$AnimationPlayer.play("FadeOut")

# Remove all nodes in root other than autoloaded nodes and the level scene
# Should be done before reloading/changing scenes
func _remove_root_nodes():
	_map_persisted = false
	var root_nodes = get_tree().get_root().get_children()
	for i in range(PERSISTENT_NODES, root_nodes.size()):
		if root_nodes[i].name == MAP_SCENE_NAME and get_tree().current_scene.name == MAP_SCENE_NAME:
			root_nodes[i].visible = false
			print_debug(root_nodes[i].visible)
			_map_persisted = true
			continue
		root_nodes[i].queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	match (anim_name):
		"FadeIn":	# Reload current scene if no next scene specified
			if _next_scene == "":
				_remove_root_nodes()
				get_tree().reload_current_scene()
			else:
				if get_tree().current_scene.name == MAP_SCENE_NAME and _next_scene != MAP_SCENE_PATH:
					print_debug("first")
					_remove_root_nodes()
					var new_scene = load(_next_scene).instance()
					get_tree().get_root().add_child(new_scene)

					_next_scene = ""
					_in_transition = false
					get_tree().get_root().get_node("Map/CanvasLayer/Fade").hide()
				elif _next_scene == MAP_SCENE_PATH:
					print_debug("sec")
					_remove_root_nodes()
					if _map_persisted:
						get_tree().get_root().get_node("Map").visible = true
						get_tree().get_root().get_node("Map/CanvasLayer/Fade").fade_out()
					else:
						_remove_root_nodes()
						get_tree().change_scene(_next_scene)
					_next_scene = ""
					_in_transition = false
				else:
					print_debug("thir")
					_remove_root_nodes()
					get_tree().change_scene(_next_scene)
			
			# Make sure to unpause after loading new scene if was paused previously
			if get_tree().paused:
				get_tree().paused = false
			emit_signal("fade_in_finished")
		"FadeOut": 
			hide()
			emit_signal("fade_out_finished")
