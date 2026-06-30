extends Node

@export var targetButton: BaseButton
@export var gameName: String
@export var gamePath: String

func _ready() -> void:
	targetButton.pressed.connect(onTargetButtonPressed)
	#targetButton.pivot_offset = targetButton.size / 2

func onTargetButtonPressed() -> void:
	#print(gameName + " selected")
	get_tree().change_scene_to_file(gamePath)
