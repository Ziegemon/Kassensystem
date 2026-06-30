class_name Path

var pathFunction: Callable
var description: String

func _init(pathFunction: Callable, description: String) -> void:
	self.pathFunction = pathFunction
	self.description = description
