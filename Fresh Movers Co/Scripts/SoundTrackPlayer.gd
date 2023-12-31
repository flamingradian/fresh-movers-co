# SPDX-License-Identifier: MIT

extends AudioStreamPlayer

var soundTrack = preload("res://Sounds/Fresh Movers Co.wav")
onready var levelManager = get_node("/root/Main/LevelManager")

var muted = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_volume_db(-25)
	self.stream = soundTrack
	self.play()

# Loop the soundtrack.
func _on_finished():
	self.play()
