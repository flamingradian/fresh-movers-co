extends AudioStreamPlayer

var soundTrack = preload("res://Sounds/Fresh Movers Co.wav")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_volume_db(-25)
	self.stream = soundTrack


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not self.is_playing():
		self.play()
