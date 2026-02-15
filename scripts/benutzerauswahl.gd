extends Control
class_name Benutzerauswahl

#---------------------------------------------------------------------------------------------------

@export var button_number : int
@export var user : user_data

@export var selected_button_color : Color
var basic_button_color = Color(0.4, 0.4, 0.4)

var style_names = ["normal", "pressed", "hover", "hover_pressed", "disabled", "focus"]

signal user_selected(button_number)

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
	
	if user != null:
		setupUser()

#---------------------------------------------------------------------------------------------------

#func _process(delta: float) -> void:
#	pass


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------

func setupUser():
	label_number.hide()
	label_number_s.show()
	#background.color = selected_button_color
	
	label_name.text = user.username
	label_name.show()

#---------------------------------------------------------------------------------------------------

func removeUser():
	label_number_s.hide()
	label_name.hide()
	label_number.show()
	#background.color = basic_button_color
	
	label_name.text = ""

#---------------------------------------------------------------------------------------------------

func userSelected():
	background.color = selected_button_color
	
	for child in get_node("../../../../keyboard/buttons_main/GridContainer").get_children():
		#child.normal.bg_color = selected_button_color
		
		for style in style_names:
			var style_box = child.get_theme_stylebox(style)
			var new_style_box = style_box.duplicate()
			new_style_box.bg_color = selected_button_color
			child.add_theme_stylebox_override(style, new_style_box)

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func userDeSelected():
	background.color = basic_button_color
	for child in get_node("../../../../keyboard/buttons_main/GridContainer").get_children():
		#child.normal.bg_color = basic_button_color
		
		for style in style_names:
			var style_box = child.get_theme_stylebox(style)
			var new_style_box = style_box.duplicate()
			new_style_box.bg_color = basic_button_color
			child.add_theme_stylebox_override(style, new_style_box)

#---------------------------------------------------------------------------------------------------

#func _on_user_changed() -> void:
	#setupUser()

#---------------------------------------------------------------------------------------------------

#func _on_user_removed() -> void:
	#removeUser()

#---------------------------------------------------------------------------------------------------

func _on_button_button_up() -> void:
	emit_signal("user_selected", button_number)
