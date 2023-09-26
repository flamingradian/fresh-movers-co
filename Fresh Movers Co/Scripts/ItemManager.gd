extends Node

var itemsInTruck = 0
var scoreToAdd = 0
func AddItemToTruck():
	itemsInTruck += 1
	scoreToAdd += 10
	
		

var isItemSelected = false setget SetIsItemSelected, GetIsItemSelected
func SetIsItemSelected(new_value):
	isItemSelected = new_value
func GetIsItemSelected():
	return isItemSelected

var deselectOnly = false setget SetIsItemSelected, GetIsItemSelected # Prevent user from deselecting and selecting in the same mouse click
func SetDeselectOnly(new_value):
	deselectOnly = new_value
func GetDeselectOnly():
	return deselectOnly

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
