extends Node

@export var label: Label
@export var quitButton: TextureButton
@export var quitScreenPath: String

func _ready() -> void:
	quitButton.pressed.connect(onQuitButtonPressed)
	label.text = "Statistics:\nFly catcher highscore:\nEASY: %s\nNORMAL: %s\nRAGE: %s\nASIAN: %s" % [
		FlyCatcherGlobal.highscore[FlyCatcherGlobal.Difficulty.EASY],
		FlyCatcherGlobal.highscore[FlyCatcherGlobal.Difficulty.NORMAL],
		FlyCatcherGlobal.highscore[FlyCatcherGlobal.Difficulty.RAGE],
		FlyCatcherGlobal.highscore[FlyCatcherGlobal.Difficulty.ASIAN]
	]

func onQuitButtonPressed() -> void:
	get_tree().change_scene_to_file(quitScreenPath)
