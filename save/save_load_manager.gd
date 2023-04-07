# Save load manager singleton
extends Node

const SAVE_PATH = "user://sav.json"

# Default data to be saved with new save file
var _default_data = {
	"best_depth" : 0,
	
	"fast_mode" : false,
	"sounds_on" : true,
	"music_on" : true,
}

func save_data(data):
	# Create and open file
	var save_file = File.new()
	save_file.open_encrypted_with_pass(SAVE_PATH, File.WRITE, "")
	
	# Convert data to json, store, and close file
	save_file.store_line(to_json(data))
	save_file.close()

func load_data():
	# If no file to load from, first create save file with default values
	var save_file = File.new()
	if not save_file.file_exists(SAVE_PATH):
		save_data(_default_data)
		
	# Open file
	save_file.open_encrypted_with_pass(SAVE_PATH, File.READ, "")

	# Parse data then close file
	var data = parse_json(save_file.get_as_text())
	save_file.close()

	return data

# Reset data
func reset_data():
	save_data(_default_data)

# Check if save file exists
func check_save():
	var dir = Directory.new()
	var save = dir.file_exists(SAVE_PATH)
	return save