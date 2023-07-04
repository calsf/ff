extends StatusIcon
class_name StatusIconChargeBlock

func set_info(face, target):
	status_name = face.face_name
	status_info = "Gain " + str(face.num_value * 2) + " block. Block reduces incoming damage."
	$NumValue.text = str(face.num_value * 2)
