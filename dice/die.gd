class_name Die

# A die must have 6 faces
const NUM_FACES = 6

var number_icon : Texture
var faces = []
var curr_face = null
var is_selected = false
var is_used = false
var is_empty = false

var action_set = false
var action_discard = false

var target = null

func _init(num_path, f=[]):
	number_icon = load(num_path)
	
	# Set to empty die if is not initialized with correct number of faces
	if f.size() != NUM_FACES:
		var face_empty = FaceEmpty.new()
		self.faces = [face_empty, face_empty, face_empty, face_empty, face_empty, face_empty]
		is_empty = true
		return
	
	is_empty = false
	self.faces = f

func _ready():
	pass

func reset_die():
	curr_face = null
	action_set = false
	action_discard = false
	target = null

func on_play(combat, dice_index):
	yield(curr_face.on_play(combat, target, dice_index), "completed")

func on_discard(combat):
	curr_face.on_discard(combat)

func get_die_data():
	return {
		"faces": [
			faces[0].get_face_data(),
			faces[1].get_face_data(),
			faces[2].get_face_data(),
			faces[3].get_face_data(),
			faces[4].get_face_data(),
			faces[5].get_face_data(),
		]
	}

