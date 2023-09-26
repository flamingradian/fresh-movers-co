extends Node


var score = 0

var levelNum = 0

var levels = [
	preload("res://Scenes/TestLevel.tscn"),
]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	StartNextLevel()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func StartNextLevel():
	self.get_child(0).queue_free()
	self.add_child(levels[levelNum].instance())
	levelNum += 1
