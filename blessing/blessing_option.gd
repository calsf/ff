extends Control
class_name BlessingOption

var blessing_container = null

func _ready():
	blessing_container = self.get_parent()
	self.connect("gui_input", self, "_on_blessing_pressed")
	self.connect("mouse_entered", self, "_on_blessing_entered")
	self.connect("mouse_exited", self, "_on_blessing_exited")
	self.modulate = Color(.95, .95, .95, 1)

func _on_blessing_pressed(event):
	pass

func _on_blessing_entered():
	self.rect_scale = Vector2(1.05, 1.05)
	self.modulate = Color(1, 1, 1, 1)

func _on_blessing_exited():
	self.rect_scale = Vector2(1, 1)
	self.modulate = Color(.95, .95, .95, 1)
