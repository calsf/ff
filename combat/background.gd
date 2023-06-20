extends TextureRect

func _ready():
	modulate = Color(LevelDepth.get_depth_color())
