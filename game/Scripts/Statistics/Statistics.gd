extends Node

@export var label: Label
@export var quitButton: TextureButton
@export var quitScreenPath: String

func _ready() -> void:
	quitButton.pressed.connect(onQuitButtonPressed)
	label.text = "Statistics for user %s:\n\n" % Main.current_selected_user_name
	label.text += "Fly catcher highscore:\nEASY: %s\nNORMAL: %s\nRAGE: %s\nASIAN: %s\n" % [
		FlyCatcherGlobal.userHighscores[Main.current_selected_user_name][FlyCatcherGlobal.Difficulty.EASY],
		FlyCatcherGlobal.userHighscores[Main.current_selected_user_name][FlyCatcherGlobal.Difficulty.NORMAL],
		FlyCatcherGlobal.userHighscores[Main.current_selected_user_name][FlyCatcherGlobal.Difficulty.RAGE],
		FlyCatcherGlobal.userHighscores[Main.current_selected_user_name][FlyCatcherGlobal.Difficulty.ASIAN]
	]

func onQuitButtonPressed() -> void:
	get_tree().change_scene_to_file(quitScreenPath)
