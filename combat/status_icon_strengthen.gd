extends StatusIcon
class_name StatusIconChargeAttack

func _init_info():
	status_name = "STRENGTHEN"

# Used to set status info directly
func set_status_info(info):
	status_info = info
