extends Control

func display_number_popup(text, color, original_label):
	for n in self.get_children():
		if not n.visible:
			n.set_and_activate_label(text, color, original_label)
			return
