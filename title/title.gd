extends Node2D

func _ready():
	# Title should always been normal time scale
	Engine.time_scale = 1.0
	
	# Reset singleton vals
	PlayerHealth.reset_health()
	PlayerDiceBank.reset_dice_bank()
	LevelDepth.reset_level_depth()

func play_title_music():
	GlobalMusic.play("Title")
