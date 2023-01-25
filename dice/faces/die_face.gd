extends Node
class_name DieFace

var face_name : String
var face_info : String
var icon : Texture
var num_value : int

func _ready():
	pass

# Plays the die face, does nothing by default
func on_play():
	pass

# Discards the die face, gains favor
func on_discard():
	# TODO: Discard for favor
	pass
