extends Node2D

onready var levelManager = get_node("/root/Main/LevelManager")
onready var itemManager = get_node("/root/Main/LevelManager/Level/ItemManager")
var isChangingAlpha = false
var storageAlpha = 0.2
var velocity = Vector2(0, 0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# This is the handler for completing the level and starts the animation where
# the truck closes and drives away.
func _on_level_complete():
	isChangingAlpha = true

func _ready():
	$StorageArea.modulate.a = storageAlpha
	levelManager.connect("level_complete", self, "_on_level_complete")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$StorageArea.modulate.a = storageAlpha

	if isChangingAlpha:
		storageAlpha += delta * 0.4
		if storageAlpha >= 1:
			levelManager.SetIsDrivingAway(true)
			isChangingAlpha = false
			itemManager.DisableTruckItems()
		
	if levelManager.GetIsDrivingAway():
		var accel = Vector2(-1800, 0)
		velocity += accel * delta
		self.position = self.position + velocity * delta

