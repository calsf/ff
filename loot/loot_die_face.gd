extends Node
class_name LootDieFace

var loot_face = null

onready var _die_face_info = get_tree().get_root().get_node("Encounter/CanvasLayer/DieFaceInfo")
onready var _dice_face_selection = get_tree().get_root().get_node("Encounter/CanvasLayer/DiceFaceSelection")

func _ready():
	loot_face = LootFaceRandomizer.get_random_face()
	
	self.connect("gui_input", self, "_on_face_pressed")
	self.connect("mouse_entered", self, "_on_face_entered", [self])
	self.connect("mouse_exited", self, "_on_face_exited")
	
	set_display()

func set_display():
		var face_node = self
		
		# Set icon
		face_node.texture = loot_face.icon
		
		# Set num value
		var num_value = loot_face.num_value
		var num_value_label = face_node.get_node("NumValue")
		
		if num_value == null or num_value == 0:
			num_value_label.text = ""
		else:
			num_value_label.text = str(num_value)

# Display info for face
func _on_face_entered(face_node):
	var y_offset = Vector2(0, face_node.rect_size.y + 18)
	
	_die_face_info.set_face_info(loot_face)
	_die_face_info.set_global_position(face_node.get_global_position() - (face_node.rect_size / 1.5) + y_offset)
	
	_die_face_info.visible = true
	
	self.rect_scale = Vector2(1.05, 1.05)

# Hide info box after exiting a die face node
func _on_face_exited():
	_die_face_info.visible = false
	self.rect_scale = Vector2(1, 1)

func _on_face_pressed(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			_dice_face_selection.activate_selection(self)
			GlobalSounds.play("Loot")
