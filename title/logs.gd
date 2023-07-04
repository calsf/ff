extends Control

onready var _back_btn = $LogsInfo/BackBtn
onready var _best_depth_label = $LogsInfo/BestDepth/Label
onready var _runs_container = $LogsInfo/RunsContainer
onready var _run_log_template = $LogsInfo/RunLogTemplate
onready var _die_face_info = $DieFaceInfo
onready var _best_depth = $LogsInfo/BestDepth/Icon

var save_data = null

func _ready():
	_back_btn.connect("pressed", self, "_on_back_pressed")
	
	_best_depth.connect("mouse_entered", self, "_on_best_depth_entered")
	_best_depth.connect("mouse_exited", self, "_on_best_depth_exited")

func init_run_log_screen():
	save_data = SaveLoadManager.load_data()
	
	# Initialize best depth
	_best_depth_label.text = str(save_data["best_depth"])
	
	# Initialize labels/buttons for each run
	var count = SaveLoadManager.MAX_RUNS - 1
	for button_container in _runs_container.get_children():
		# Default to NO DATA
		var label = "NO DATA"
		
		# Get run label
		if save_data["runs"][count] != null:
			label = save_data["runs"][count]["label"]
		
		# Get button node
		var button = button_container.get_node("Button")
		
		# Set run label and connect button to set and display run log
		button.text = label
		
		# Disconnect if needed, then connect
		if button.is_connected("pressed", self, "_show_run_log_template"):
			button.disconnect("pressed", self, "_show_run_log_template")
		button.connect("pressed", self, "_show_run_log_template", [count])
		
		count -= 1
	
	self.visible = true

func _show_run_log_template(count):
	# If no data, do nothing
	if save_data["runs"][count] == null:
		return
	
	# Set and display run log with given data
	_run_log_template.set_and_display(save_data["runs"][count])
	
	GlobalSounds.play("ButtonPressed")

func _on_back_pressed():
	self.visible = false
	
	GlobalSounds.play("ButtonPressed")

func _on_best_depth_entered():
	var y_offset = Vector2(8, _best_depth.rect_size.y + 30)
	
	_die_face_info.set_face_info_directly("BEST DEPTH", "The highest depth reached.")
	_die_face_info.set_global_position(_best_depth.get_global_position() - (_best_depth.rect_size / 1.05) + y_offset)
	
	_die_face_info.visible = true

func _on_best_depth_exited():
	_die_face_info.visible = false

