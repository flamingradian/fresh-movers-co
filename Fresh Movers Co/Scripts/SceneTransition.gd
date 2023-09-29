# SPDX-License-Identifier: MIT

extends CanvasLayer

onready var levelManager = get_node("/root/Main/LevelManager")

func TransitionBlack():
	$AnimationPlayer.play("DissolveBlack")
	yield($AnimationPlayer, "animation_finished")
	levelManager.StartLevel()
	$AnimationPlayer.play_backwards("DissolveBlack")

func TransitionWhite():
	$AnimationPlayer.play("DissolveWhite")
	yield($AnimationPlayer, "animation_finished")
	levelManager.StartLevel()
	$AnimationPlayer.play_backwards("DissolveWhite")
