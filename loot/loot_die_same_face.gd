extends HBoxContainer
class_name LootDieSameFace

var die = null

onready var _die_face_info = get_tree().get_root().get_node("Encounter/CanvasLayer/DieFaceInfo")

onready var _loot = get_tree().get_root().get_node("Encounter/CanvasLayer/LootScreen")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Requiures 6 faces
	var faces = [null, null, null, null, null, null]
	
	# All faces of this die will be the same
	var same_face_type = LootFaceRandomizer.get_random_face_type()
	
	for i in range(faces.size()):
		# Create new instance for each face with same face type
		faces[i] = LootFaceRandomizer.create_new_face(same_face_type)
	
	die = Die.new("res://dice/die-numbers/die-num-new.png", faces)
	
	self.connect("gui_input", self, "_on_die_pressed")
	self.connect("mouse_entered", self, "_on_die_entered")
	self.connect("mouse_exited", self, "_on_die_exited")

	set_display()

func set_display():
	var die_faces = self.get_children()
	
	# Set dice number
	die_faces[0].texture = die.number_icon
	
	die_faces[0].connect("mouse_entered", self, "_on_face_num_entered", [die_faces[0]])
	die_faces[0].connect("mouse_exited", self, "_on_face_exited")
	
	for j in range(1, die_faces.size()):
		var face_node = die_faces[j]
		var face_obj = die.faces[j - 1]
		
		# Reset signal if needed for updated dice
		if face_node.is_connected("mouse_entered", self, "_on_face_entered"):
			face_node.disconnect("mouse_entered", self, "_on_face_entered")
		
		# Set on hover for die face
		face_node.connect("mouse_entered", self, "_on_face_entered", [face_node, face_obj])
		
		# Set on exit if not already set
		if not face_node.is_connected("mouse_exited", self, "_on_face_exited"):
			face_node.connect("mouse_exited", self, "_on_face_exited")
		
		# Set icon
		face_node.texture = face_obj.icon
		
		# Set num value
		var num_value = face_obj.num_value
		var num_value_label = face_node.get_node("NumValue")
		
		if num_value == null or num_value == 0:
			num_value_label.text = ""
		else:
			num_value_label.text = str(num_value)

# Move info box to position with the corresponding die info
func _on_face_entered(face_node, face_obj):
	# Do nothing if empty face name
	if face_obj.face_name == "":
		return
	
	var y_offset = Vector2(0, face_node.rect_size.y + 18)
	
	_die_face_info.set_face_info(face_obj)
	_die_face_info.set_global_position(face_node.get_global_position() - (face_node.rect_size / 1.5) + y_offset)
	
	_die_face_info.visible = true

# Hide info box after exiting a die face node
func _on_face_exited():
	_die_face_info.visible = false

# Scale up dice row on hover
func _on_die_entered():
	self.rect_scale = Vector2(1.05, 1.05)

# Scale back dice row to original on exit
func _on_die_exited():
	self.rect_scale = Vector2(1, 1)

# Display info for face num
func _on_face_num_entered(face_node):
	var y_offset = Vector2(0, face_node.rect_size.y + 18)
	
	var info = "Adds this die to the dice bank."
	
	_die_face_info.set_face_info_directly("ADD DIE", info)
	_die_face_info.set_global_position(face_node.get_global_position() - (face_node.rect_size / 1.5) + y_offset)
	
	_die_face_info.visible = true

func _on_die_pressed(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var added = PlayerDiceBank.add_die(die)
			
			if added:
				_on_face_exited()
				_loot.remove_loot(self)
				
				GlobalSounds.play("Loot")
			else:
				return
