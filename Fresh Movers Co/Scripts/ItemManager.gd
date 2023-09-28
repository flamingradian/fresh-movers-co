extends Node

onready var itemsList = self.get_children()
onready var levelManager = get_node("/root/Main/LevelManager")

var itemsInTruck = 0
func AddItemToTruck():
	itemsInTruck += 1
	levelManager.SetScoreToAdd(max(0, 100 - 30 * (itemsList.size() - itemsInTruck)))

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
	for item in itemsList:
		if item.isInTruck:
			itemsInTruck += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func DisableTruckItems():
	for item in itemsList:
		if item.isInTruck:
			item.visible = false
