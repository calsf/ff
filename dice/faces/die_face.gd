extends Node
class_name DieFace

var face_name : String
var face_info : String
var icon : Texture
var num_value : int
var require_target : bool

func _ready():
	pass

# Plays the die face, does nothing by default
func on_play(combat, target):
	pass

# Discards the die face, gains favor
func on_discard(combat):
	combat.add_favor(1)
