extends Node

func _ready():
	pass

func play(sound):
	if (not SaveLoadManager.check_save() or SaveLoadManager.load_data()["sounds_on"]):
		get_node(sound).play()
