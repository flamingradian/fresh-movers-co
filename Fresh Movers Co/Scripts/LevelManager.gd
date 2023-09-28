extends Node

signal level_complete

var isTransitioning = false
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
var scoreToAdd = 0 setget SetScoreToAdd
onready var scoreText = get_node("/root/Main/ScoreText")
onready var storyText = get_node("/root/Main/StoryText")
func SetScoreToAdd(new_value):
	scoreToAdd = new_value
	scoreText.text = "Score: " + str(score) + " (+" + str(scoreToAdd) + ")"

var isDrivingAway = false setget SetIsDrivingAway, GetIsDrivingAway
func SetIsDrivingAway(new_value):
	isDrivingAway = new_value
func GetIsDrivingAway():
	return isDrivingAway
	
var isLevelComplete setget , GetIsLevelComplete
func GetIsLevelComplete():
	return isLevelComplete
	
onready var restartButton = get_node("/root/Main/RestartButton")

var levelNum = 0
var levels = [
	preload("res://Scenes/Levels/Start.tscn"),
	preload("res://Scenes/Levels/Level1.tscn"),
	preload("res://Scenes/Levels/Level2.tscn"),
	preload("res://Scenes/Levels/Level3.tscn"),
	preload("res://Scenes/Levels/Level4.tscn"),
	preload("res://Scenes/Levels/Level5.tscn"),
	preload("res://Scenes/Levels/Level6.tscn"),
	preload("res://Scenes/Levels/Level7.tscn"),
	preload("res://Scenes/Levels/Level8.tscn"),
	preload("res://Scenes/Levels/Level9.tscn"),
	preload("res://Scenes/Levels/Level10.tscn"),
	preload("res://Scenes/Levels/Level11.tscn"),
	preload("res://Scenes/Levels/Level12.tscn"),
	preload("res://Scenes/Levels/Level13.tscn"),
	preload("res://Scenes/Levels/Level14.tscn"),
	preload("res://Scenes/Levels/Level15.tscn"),
]
var storyTextList = [
	"",
	"Use your mouse to drag items into the truck. Press space to drive away.",
	"This is harder than it looks. I thought we just had to put them in the truck.",
	"Client: Are you sure this will fit?",
	"Our house was a mess. Glad we can finally leave it behind.",
	"Maybe we shouldn’t have stored our items in barrels...",
	"This will be the last obstacle we will need to move out of our way.",
	"Be careful! I have some fragile items in there.",
	"It’s great to have someone to lean on. Thank you.",
	"Fragile relationships are the worst! I’m ready to start anew.",
	"We wanted to move out quickly.",
	"It was tough trying to balance everything out.",
	"Please keep these boxes right side up.",
	"I'm planning to move closer to my family. I want to visit often.",
	"When I face an issue, I try to shake things up. Find some new perspectives.",
	"We gave it some good thought. In the end, we decided to start fresh.",
]


# Called when the node enters the scene tree for the first time.
func _ready():
	restartButton.connect("pressed", self, "_on_RestartButton_pressed")
	restartButton.visible = false
	StartLevel()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		advance()
	
	if isLevelComplete:
		storyText.modulate.a -= delta

func advance():
	if levelNum == 0 and not isTransitioning:
		StartNextLevel()
	else:
		if not isLevelComplete:
			isLevelComplete = true
			emit_signal("level_complete")
		elif not isTransitioning:
			if levelNum < levels.size() - 1 and isDrivingAway:
				StartNextLevel()

# End the current level and start a new one. It may be the same level in the
# case of a reset, or the next one if the player finishes the current one.
func StartLevel():
	self.remove_child($Level)
	self.add_child(levels[levelNum].instance())
	isLevelComplete = false
	isDrivingAway = false
	SetScoreToAdd(0) 
	storyText.text = storyTextList[levelNum]
	storyText.modulate.a = 1
	isTransitioning = false
	if levelNum > 0:
		restartButton.visible = true

func StartNextLevel():
	levelNum += 1
	score += scoreToAdd
	SceneTransition.TransitionWhite()
	isTransitioning = true
	
func _on_RestartButton_pressed():
	if not isTransitioning:
		SceneTransition.TransitionBlack()
		isTransitioning = true

func _on_advance_button_pressed():
	advance()



