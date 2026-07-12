extends Node

@export var targetButton: BaseButton
@export var gameName: String
@export var gamePath: String

func _ready() -> void:
	targetButton.pressed.connect(onTargetButtonPressed)
	#targetButton.pivot_offset = targetButton.size / 2

func onTargetButtonPressed() -> void:
	if get_tree().current_scene.scene_file_path == "res://game/Scenes/FlyCatcher.tscn":
		FlyCatcherGlobal.gameState = FlyCatcherGlobal.GameState.Start

	if gamePath == "res://scenes/main.tscn":
		Main.show()
		get_tree().current_scene.hide()
		get_tree().current_scene = Main
		
	else:
		get_tree().change_scene_to_file(gamePath)
