extends HBoxContainer
class_name LootDieRemove

onready var _die_face_info = get_tree().current_scene.get_node("CanvasLayer/DieFaceInfo")
onready var _dice_bank_selection = get_tree().current_scene.get_node("CanvasLayer/DiceBankSelection")

func _ready():
	self.connect("gui_input", self, "_on_die_pressed")
	self.connect("mouse_entered", self, "_on_die_entered")
	self.connect("mouse_exited", self, "_on_die_exited")

	set_display()

func set_display():
	var die_faces = self.get_children()
	
	for face in die_faces:
		face.connect("mouse_entered", self, "_on_face_num_entered", [face])
		face.connect("mouse_exited", self, "_on_face_exited")

# Scale up dice row on hover
func _on_die_entered():
	self.rect_scale = Vector2(1.05, 1.05)

# Scale back dice row to original on exit
func _on_die_exited():
	self.rect_scale = Vector2(1, 1)

# Display info for face num
func _on_face_num_entered(face_node):
	var y_offset = Vector2(0, face_node.rect_size.y + 18)
	
	var info = "Select and remove a die from dice bank. Cannot be used if only one die left."
	
	_die_face_info.set_face_info_directly("REMOVE DIE", info)
	_die_face_info.set_global_position(face_node.get_global_position() - (face_node.rect_size / 1.5) + y_offset)
	
	_die_face_info.visible = true

# Hide info box after exiting a die face node
func _on_face_exited():
	_die_face_info.visible = false

func _on_die_pressed(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			# Must keep min of 1 die
			if PlayerDiceBank.get_owned_dice() <= 1:
				return
			
			_dice_bank_selection.activate_selection(self)
