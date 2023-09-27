extends AudioStreamPlayer

var soundTrack = preload("res://Sounds/Fresh Movers Co.wav")
onready var levelManager = get_node("/root/Main/LevelManager")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_volume_db(levelManager.musicVolume)
	self.stream = soundTrack
	self.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.set_volume_db(levelManager.musicVolume)
