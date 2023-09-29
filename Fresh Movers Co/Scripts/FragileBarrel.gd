# SPDX-License-Identifier: MIT

extends "res://Scripts/Barrel.gd"

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
		var breakingForce = 175
		if not isBroken:
			if velChange.length() > breakingForce:
				isBroken = true
				soundEffectsPlayer.stream = break2Sound
				soundEffectsPlayer.set_volume_db(-20)
				soundEffectsPlayer.play()
	if isBroken:
		if isRestartingLevel == false:
			restartTimer += delta
			if restartTimer > 1:
				isRestartingLevel = true
				levelManager.StartLevel()
		

