class_name DieFace

var face_name : String
var face_info : String
var icon : Texture
var num_value : int
var require_target : bool

func _ready():
	pass

# Plays the die face, does nothing by default
func on_play(combat, target, parent_die=0):
	pass

# Discards the die face, gains favor
func on_discard(combat):
	combat.add_favor(1)

func on_extra_play(combat, target):
	pass

# Scale num value based on depth 
func scale_num_val(scaling):
	# Scale every 2 depths
	num_value += scaling * ((LevelDepth.depth - 1) / 2)
	update_info()

func update_info():
	pass

func get_face_data():
	return {
		"face_name": face_name,
		"face_info": face_info,
		"icon": icon.resource_path,
		"num_value": num_value
	}
