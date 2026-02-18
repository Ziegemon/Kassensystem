extends Control

#---------------------------------------------------------------------------------------------------

@onready var button: Button = $Button


@export var button_number : int
@export var button_semicolon : bool = false

@export var custom_minimum_size_x : int = 120
@export var custom_minimum_size_y : int = 120

signal keyboard_button_pressed(button_number, button_semicolon)

#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _ready() -> void:
	setUpButton()


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _on_button_button_up() -> void:
	emit_signal("keyboard_button_pressed", button_number, button_semicolon)

#---------------------------------------------------------------------------------------------------

func setUpButton():
	if button_semicolon == true:
		$Button.text = ","
	else:
		$Button.text = str(button_number)
	
	button.custom_minimum_size.x = custom_minimum_size_x
	button.custom_minimum_size.y = custom_minimum_size_y
