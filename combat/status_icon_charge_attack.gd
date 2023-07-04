extends StatusIcon
class_name StatusIconChargeAttack

func set_info(face, target):
	status_name = face.face_name
	status_info = "Deal " + str(face.num_value * 2) + " damage to FACE " + str(target.enemy_num) + "."
	$NumValue.text = str(face.num_value * 2)
