extends ColorRect

# Number of nodes that should persist in root tree
# Includes autoloaded nodes
# Should free all objects after (free root_nodes[PERSISTENT_NODES + 1] and onwards)
const PERSISTENT_NODES = 4
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

# Remove all nodes in root other than autoloaded nodes
# Should be done before reloading/changing scenes
func _remove_root_nodes(persist_map=true):
	_map_persisted = false
	var root_nodes = get_tree().get_root().get_children()
	for i in range(PERSISTENT_NODES, root_nodes.size()):
		# Persist map if conditions are met
		if root_nodes[i].name == MAP_SCENE_NAME and get_tree().current_scene.name == MAP_SCENE_NAME and persist_map:
			_map_persisted = true
			continue
		
		root_nodes[i].queue_free()

func reset_fade():
	_next_scene = ""
	_in_transition = false

func _on_AnimationPlayer_animation_finished(anim_name):
	match (anim_name):
		"FadeIn":	# Reload current scene if no next scene specified
			if _next_scene == "":
				_remove_root_nodes()
				get_tree().reload_current_scene()
			else:
				if get_tree().current_scene.name == MAP_SCENE_NAME and _next_scene != MAP_SCENE_PATH:
					print_debug("Persisting Map")
					_remove_root_nodes()
					var new_scene = load(_next_scene).instance()
					get_tree().get_root().add_child(new_scene)
					
					# Hide map
					get_tree().get_root().get_node("Map").hide_map()
				elif _next_scene == MAP_SCENE_PATH:
					_remove_root_nodes()
					if _map_persisted:
						print_debug("Going to map, map already exists.")
						
						# Show map
						get_tree().get_root().get_node("Map").show_map()
					else:
						print_debug("Going to map, map does not exist.")
						
						_remove_root_nodes()
						get_tree().change_scene(_next_scene)
				else:
					print_debug("Changing scenes.")
					_remove_root_nodes()
					get_tree().change_scene(_next_scene)
			
			# Make sure to unpause after loading new scene if was paused previously
			if get_tree().paused:
				get_tree().paused = false
			emit_signal("fade_in_finished")
		"FadeOut": 
			hide()
			emit_signal("fade_out_finished")
