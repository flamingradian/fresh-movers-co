extends "res://Scripts/Item.gd"

onready var startRotation = self.get_rotation_degrees()
var restartTimer = 0
var isRestartingLevel = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isInTruck and not levelManager.GetIsDrivingAway():
		if not isBroken:
			if abs(self.get_rotation_degrees() - startRotation) > 3:
				isBroken = true
				soundEffectsPlayer.stream = break1Sound
				soundEffectsPlayer.set_volume_db(-15)
				soundEffectsPlayer.play()
	if isBroken:
		if isRestartingLevel == false:
			restartTimer += delta
			if restartTimer > 1:
				isRestartingLevel = true
				levelManager.StartLevel()
