extends StatusIcon
class_name StatusIconChargeBlock

func set_info(face, target):
	status_name = face.face_name
	status_info = "Next turn, block " + str(face.num_value * 2) + " incoming damage."
