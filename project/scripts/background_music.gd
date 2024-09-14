extends AudioStreamPlayer2D


const MEGA_QUEST_REMASTERED___LEVEL_1 = preload("res://assets/music/Mega Quest Remastered - Level 1.ogg")
const MEGA_QUEST_REMASTERED___LEVEL_2 = preload("res://assets/music/Mega Quest Remastered - Level 2.ogg")
var mucis_list = [MEGA_QUEST_REMASTERED___LEVEL_1, MEGA_QUEST_REMASTERED___LEVEL_2]

func _ready() -> void:
	stream = mucis_list.pick_random()
	play()
