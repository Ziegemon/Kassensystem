extends Node2D

#---------------------------------------------------------------------------------------------------

@export var button_number : int
var basic_button_color = Color(0.4, 0.4, 0.4)
@export var selected_button_color : Color
@export var user : user_data

signal user_selected()

#signal user_changed
#signal user_removed

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

@onready var background: ColorRect = $background
@onready var label_number: Label = $label_number
@onready var label_name: Label = $label_name
@onready var label_number_s: Label = $label_number_s



#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _ready() -> void:
	background.color = basic_button_color
	label_number.text = str(button_number)
	label_number_s.text = str(button_number)

#---------------------------------------------------------------------------------------------------

#func _process(delta: float) -> void:
#	pass


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------

func setupUser():
	label_number.hide()
	label_number_s.show()
	background.color = selected_button_color
	
	
	label_name.text = user.username
	label_name.show()

#---------------------------------------------------------------------------------------------------

func removeUser():
	label_number_s.hide()
	label_name.hide()
	label_number.show()
	background.color = basic_button_color
	
	label_name.text = ""

#---------------------------------------------------------------------------------------------------

#func _on_user_changed() -> void:
	#setupUser()

#---------------------------------------------------------------------------------------------------

#func _on_user_removed() -> void:
	#removeUser()

#---------------------------------------------------------------------------------------------------

func _on_button_button_up() -> void:
	pass # Replace with function body.
