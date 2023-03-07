extends StatusIcon
class_name StatusIconChargeAttack

func set_info(face, target):
	status_name = face.face_name
	status_info = "Next turn, deal " + str(face.num_value * 2) + " damage to FACE " + str(target.enemy_num) + "."
