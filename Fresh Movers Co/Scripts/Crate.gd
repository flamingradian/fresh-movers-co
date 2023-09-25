extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print(self.is_pickable())
	pass # Replace with function body.

# Helper to set the texture when this is unselected.
func set_default_texture():
	$Sprite.texture = load("res://Sprites/crate.png")

# Helper to set the texture when this is selected.
func set_selected_texture():
	$Sprite.texture = load("res://Sprites/crate_selected.png")

# Exit the initial draggable state of the box, allowing it to be subject to
# physics and unselecting it.
func edit_mode_exit():
	self.set_default_texture()
	self.gravity_scale = 1

func _on_mouse_entered():
	self.set_selected_texture()

func _on_mouse_exited():
	self.set_default_texture()
