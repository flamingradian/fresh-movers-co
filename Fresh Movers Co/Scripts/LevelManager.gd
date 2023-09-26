extends Node


var score = 0
var isLevelComplete setget , GetIsLevelComplete
func GetIsLevelComplete():
	return isLevelComplete
	
var levelNum = 0

var levels = [
	preload("res://Scenes/TestLevel.tscn"),
	preload("res://Scenes/TestLevel.tscn")
]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var restartButton = get_node("/root/Main/RestartButton")
	restartButton.connect("pressed", self, "_on_RestartButton_pressed")
	StartLevel()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		if not isLevelComplete:
			isLevelComplete = true
		else:
			if levelNum < levels.size() - 1:
				StartNextLevel()

# End the current level and start a new one. It may be the same level in the
# case of a reset, or the next one if the player finishes the current one.
func StartLevel():
	$Level.free()
	self.add_child(levels[levelNum].instance())
	isLevelComplete = false
	

func StartNextLevel():
	levelNum += 1
	StartLevel()
	
func _on_RestartButton_pressed():
	StartLevel()
