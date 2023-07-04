extends Control

onready var _back_btn = $LogsInfo/BackBtn
onready var _best_depth_label = $LogsInfo/BestDepth/Label
onready var _runs_container = $LogsInfo/RunsContainer
onready var _run_log_template = $LogsInfo/RunLogTemplate

var save_data = null

func _ready():
	_back_btn.connect("pressed", self, "_on_back_pressed")

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


