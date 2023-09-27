extends "res://Scripts/Item.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_default_texture():
	$NinePatchRect.texture = load("res://Sprites/barrel.png")

# Helper to set the texture when this is in an invalid position.
func set_invalid_texture():
	$NinePatchRect.texture = load("res://Sprites/barrel_invalid.png")

# Helper to set the texture when this is selected.
func set_selected_texture():
	$NinePatchRect.texture = load("res://Sprites/barrel_selected.png")
