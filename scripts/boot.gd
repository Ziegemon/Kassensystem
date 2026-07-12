extends Node

func _ready() -> void:
	Main.show()
	get_tree().current_scene = Main
	queue_free()
