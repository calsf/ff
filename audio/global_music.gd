extends Node

func _ready():
	pass

func play(music):
	if (not SaveLoadManager.check_save() or SaveLoadManager.load_data()["music_on"]):
		get_node(music).play()

# Should be called when music is toggled on/off
func update_player_volumes(music_on):
	if music_on:
		for player in get_children():
			player.set_volume_db(0)
	else:
		for player in get_children():
			player.set_volume_db(-80)
