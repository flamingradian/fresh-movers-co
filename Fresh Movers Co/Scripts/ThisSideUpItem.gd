extends "res://Scripts/Item.gd"

onready var startRotation = self.get_rotation_degrees()
var restartTimer = 0
var isRestartingLevel = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isInTruck:
		if not isBroken:
			if abs(self.get_rotation_degrees() - startRotation) > 20:
				isBroken = true
				audioStreamPlayer.stream = breakSound
				audioStreamPlayer.play()
		else:
			if isRestartingLevel == false:
				restartTimer += delta
				if restartTimer > 1:
					isRestartingLevel = true
					levelManager.StartLevel()
