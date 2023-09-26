extends "res://Scripts/Item.gd"

var pVelocity = Vector2(0, 0)
var isBroken = false
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
		var velChange = self.linear_velocity - pVelocity
		var breakingForce = 300
		if not isBroken:
			if velChange.length() > breakingForce:
				isBroken = true
		else:
			if isBroken and isRestartingLevel == false:
				restartTimer += delta
				if restartTimer > 1:
					isRestartingLevel = true
					levelManager.StartLevel()
		
		pVelocity = self.linear_velocity

