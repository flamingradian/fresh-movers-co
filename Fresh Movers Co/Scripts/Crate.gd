# SPDX-License-Identifier: GPL-3.0-or-later

extends RigidBody2D

# Objects appear at origin briefly on game start. This will prevent Area2D
# detection from triggering when that happens.
var startDetection = false

onready var startTransform = self.get_transform()
var isInTruck = false
var isHovering = false
var isSelected = false
var isHoveringOverTruck = false
var collideCount = 0

onready var itemManager = self.get_parent()
var truckStorageAreaPath = "/root/Level/Truck/Storage Area"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.layers = 0x2

	var truckStorageArea = get_node(truckStorageAreaPath)
	truckStorageArea.connect("area_entered", self, "_on_Truck_Area2D_area_entered")
	truckStorageArea.connect("area_exited", self, "_on_Truck_Area2D_area_exited")

	# Do not check if the 
	#var truckWalls = get_node("Truck/Floor and Walls/Area2D")
	#truckWalls.connect("area_entered", self, "_on_Area2D_area_entered")
	#truckWalls.connect("area_entered", self, "_on_Area2D_area_entered")

func _process(delta):
	startDetection = true
	if isSelected:
		self.position = get_viewport().get_mouse_position()
		self.z_index = 1
	else:
		self.z_index = 0
		if isInTruck == false:
			self.transform = startTransform

# Helper to set the texture when this is unselected.
func set_default_texture():
	$NinePatchRect.texture = load("res://Sprites/crate.png")

# Helper to set the texture when this is selected.
func set_selected_texture():
	$NinePatchRect.texture = load("res://Sprites/crate_selected.png")

# Exit the initial draggable state of the box, allowing it to be subject to
# physics and unselecting it.
func edit_mode_exit():
	pass

func _on_mouse_entered():
	isHovering = true
	if itemManager.GetIsItemSelected() == false and itemManager.GetDeselectOnly() == false and isInTruck == false:
		self.set_selected_texture()

func _on_mouse_exited():
	isHovering = false
	if itemManager.GetIsItemSelected() == false and itemManager.GetDeselectOnly() == false and isInTruck == false:
		self.set_default_texture()

func on_mouse_pressed():
	if isSelected:
		if isHoveringOverTruck == true:
			# We only want the box to collide with one object,
			# which is the inside of the truck.
			if collideCount == 1:
				isInTruck = true
				isSelected = false
				itemManager.SetIsItemSelected(false)
				itemManager.AddItemToTruck()

				self.set_default_texture()
				self.layers = 0x1
				self.gravity_scale = 8
		else: # Deselect crate
			isSelected = false
			itemManager.SetIsItemSelected(false)
			itemManager.SetDeselectOnly(true)
	else:
		if itemManager.GetIsItemSelected() == false and isHovering and isInTruck == false and itemManager.GetDeselectOnly() == false:
			isSelected = true
			itemManager.SetIsItemSelected(true)
			self.set_default_texture()

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed(): # Mouse Press
			on_mouse_pressed()

		if event.is_pressed() == false: # Mouse Release
			itemManager.SetDeselectOnly(false)

# Keep track of how many objects this box is colliding with.
func _on_Area2D_area_entered(area):
	if startDetection:
		collideCount += 1

func _on_Area2D_area_exited(area):
	if startDetection:
		collideCount -= 1

# Keep track of when the box enters the truck.
func _on_Truck_Area2D_area_entered(area):
	if startDetection:
		isHoveringOverTruck = true

func _on_Truck_Area2D_area_exited(area):
	if startDetection:
		isHoveringOverTruck = false
