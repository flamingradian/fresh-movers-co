extends Node2D

onready var levelManager = get_node("/root/Main/LevelManager")
onready var itemManager = get_node("/root/Main/LevelManager/Level/ItemManager")
var isDrivingAway = false
var isChangingAlpha = false
var storageAlpha = 0.2
var velocity = Vector2(0, 0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	isChangingAlpha = true
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(delta)
	$StorageArea.modulate.a = storageAlpha
	if Input.is_action_just_pressed("ui_select"):
		isChangingAlpha = true
	
	if isChangingAlpha:
		storageAlpha += delta
		if storageAlpha >= 1:
			isDrivingAway = true
			isChangingAlpha = false
			itemManager.DisableTruckItems()
		
	if isDrivingAway:
		var accel = Vector2(-1800, 0)
		velocity += accel * delta
		self.position = self.position + velocity * delta

