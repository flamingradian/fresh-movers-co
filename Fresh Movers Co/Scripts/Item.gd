# SPDX-License-Identifier: MIT

extends RigidBody2D

# Objects appear at origin briefly on game start. This will prevent Area2D
# detection from triggering when that happens.
var startDetection = false

onready var startTransform = self.get_transform()
export var isInTruck = false
var isSelected = false
var isHoveringOverTruck = false
var collideCount = 0
var collideSoundTimer = 0
var isBroken = false
var pVel = Vector2(0, 0)
var velChange = Vector2(0, 0)

onready var levelManager = get_node("/root/Main/LevelManager")
onready var itemManager = self.get_parent()
onready var soundEffectsPlayer = get_node("/root/Main/SoundEffectsPlayer")
var truckStorageAreaPath = "/root/Main/LevelManager/Level/Truck/StorageArea"

var thudSound = preload("res://Sounds/Thud.wav")
var break1Sound = preload("res://Sounds/Break1.wav")
var break2Sound = preload("res://Sounds/Break2.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	if isInTruck:
		self.set_default_texture()
		self.layers = 0x1
		self.gravity_scale = 8
	else:
		self.layers = 0x2
		self.sleeping = true
	
	var truckStorageArea = get_node(truckStorageAreaPath)
	truckStorageArea.connect("area_entered", self, "_on_Truck_Area2D_area_entered")
	truckStorageArea.connect("area_exited", self, "_on_Truck_Area2D_area_exited")

func _process(delta):
	startDetection = true
	collideSoundTimer += delta
	velChange = self.linear_velocity - pVel
	
	if Input.is_action_just_pressed("ui_select"):
			isSelected = false
	
	if isSelected:
		var moveIncrement = 999
		if isHoveringOverTruck and collideCount == 1:
			moveIncrement = 20
			
		var displacement = get_viewport().get_mouse_position() - self.position
		if displacement.length() < moveIncrement:
			self.position = get_viewport().get_mouse_position()
		else:
			var theta = atan2(displacement.y, displacement.x)
			self.position += Vector2(cos(theta), sin(theta)) * moveIncrement
		
		self.z_index = 1
	else:
		if isInTruck == false:
			self.z_index = 0
			self.transform = startTransform
		else:
			self.z_index = -2
			
	
	
	if not soundEffectsPlayer.is_playing() \
	   and velChange.length() > 30 \
	   and isInTruck \
	   and not levelManager.GetIsDrivingAway() \
	   and not isBroken:
		soundEffectsPlayer.stream = thudSound
		soundEffectsPlayer.set_volume_db((min(velChange.length()/10, 30) - 40))
		soundEffectsPlayer.play()
	
	pVel = self.linear_velocity
			

# Helper to set the texture when this is unselected.
func set_default_texture():
	$NinePatchRect.texture = load("res://Sprites/crate.png")

# Helper to set the texture when this is in an invalid position.
func set_invalid_texture():
	$NinePatchRect.texture = load("res://Sprites/crate_invalid.png")

# Helper to set the texture when this is selected.
func set_selected_texture():
	$NinePatchRect.texture = load("res://Sprites/crate_selected.png")

# Exit the initial draggable state of the box, allowing it to be subject to
# physics and unselecting it.
func edit_mode_exit():
	pass

# Helper function to tell whether this box can be selected.
#
# This box can be selected when there is no other box selected, the mouse press
# is not used for another purpose, and when this box can still be placed.
#
# GDScript seems to permit wrapping lines, so separate each statement to avoid
# a line with more than 80 columns.
func can_select_box():
	return not levelManager.GetIsLevelComplete() \
	   and not itemManager.GetIsItemSelected() \
	   and not itemManager.GetDeselectOnly() \
	   and not isInTruck

func _on_mouse_entered():
	if can_select_box():
		self.set_selected_texture()

func _on_mouse_exited():
	if can_select_box():
		self.set_default_texture()

func _on_mouse_pressed():
	if can_select_box():
		isSelected = true
		itemManager.SetIsItemSelected(true)
		self.set_default_texture()

func _on_mouse_released():
	if isSelected:
		# We only want the box to collide with one object,
		# which is the inside of the truck.
		if isHoveringOverTruck == true and collideCount == 1:
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

# Keep track of how many objects this box is colliding with.
func _on_Area2D_area_entered(area):
	if startDetection:
		collideCount += 1
		if isSelected and collideCount > 1:
			self.set_invalid_texture()

func _on_Area2D_area_exited(area):
	if startDetection:
		collideCount -= 1
		if collideCount <= 1:
			self.set_default_texture()

# Keep track of when the box enters the truck.
func _on_Truck_Area2D_area_entered(area):
	if startDetection and area.get_parent().name == self.name:
		isHoveringOverTruck = true

func _on_Truck_Area2D_area_exited(area):
	if startDetection and area.get_parent().name == self.name:
		isHoveringOverTruck = false
