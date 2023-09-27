extends Node2D

onready var levelManager = get_node("/root/Main/LevelManager")
var isHovering = false

func _ready():
	$Fill.set_size(Vector2(75, 8))

func _input(event):
	if isHovering and Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mousePos = get_viewport().get_mouse_position()
		levelManager._on_Music_Slider_value_changed((mousePos.x - self.position.x) / 150 * 40 - 20)
		$Fill.set_size(Vector2(max(0, min(mousePos.x - self.position.x, 150)), 8))


func _on_Area2D_mouse_entered():
	isHovering = true

func _on_Area2D_mouse_exited():
	isHovering = false
