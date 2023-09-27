extends Node

signal level_complete

var soundTrackMuted = false
var sfxMuted = false

func _on_Music_Slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundTrack"), value)
	if value < -19:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundTrack"), true)   
		soundTrackMuted = true
	elif soundTrackMuted:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundTrack"), false)

func _on_SFX_Slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), value)
	if value < -19:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"), true)   
		sfxMuted = true
	elif sfxMuted:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"), false)

var score = 0
var isDrivingAway = false setget SetIsDrivingAway, GetIsDrivingAway
func SetIsDrivingAway(new_value):
	isDrivingAway = new_value
func GetIsDrivingAway():
	return isDrivingAway
	
var isLevelComplete setget , GetIsLevelComplete
func GetIsLevelComplete():
	return isLevelComplete
	
var levelNum = 0
var levels = [
	#preload("res://Scenes/Levels/Start.tscn"),
	preload("res://Scenes/Levels/Level1.tscn"),
	preload("res://Scenes/Levels/Level2.tscn"),
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
		advance()

func advance():
	if not isLevelComplete:
		isLevelComplete = true
		emit_signal("level_complete")
	else:
		if levelNum < levels.size() - 1 and isDrivingAway:
			StartNextLevel()

# End the current level and start a new one. It may be the same level in the
# case of a reset, or the next one if the player finishes the current one.
func StartLevel():
	self.remove_child($Level)
	self.add_child(levels[levelNum].instance())
	isLevelComplete = false
	isDrivingAway = false
	

func StartNextLevel():
	levelNum += 1
	SceneTransition.TransitionWhite()
	
func _on_RestartButton_pressed():
	SceneTransition.TransitionBlack()

func _on_advance_button_pressed():
	advance()



