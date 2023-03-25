extends StatusIcon
class_name StatusIconStrengthen

onready var _num_value = $NumValue

func _init_info():
	status_name = "STRENGTHEN"

# Used to set status info directly
func set_status_info(info):
	status_info = info

func set_num_value_text(val):
	_num_value.text = val
