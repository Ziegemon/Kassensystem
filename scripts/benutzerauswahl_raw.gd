extends Control
class_name Benutzerauswahl_raw

#---------------------------------------------------------------------------------------------------

@export var button_number : int

@export var selected_button_color : Color
var basic_button_color = Color(0.4, 0.4, 0.4)

var style_names = ["normal", "pressed", "hover", "hover_pressed", "disabled", "focus"]

signal user_selected(button_number)

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

@onready var background: ColorRect = $background

@export var current_item_list_array : Array[item_data_list_element]


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _ready() -> void:
	background.color = basic_button_color


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func userSelected():
	background.color = selected_button_color
	
	for child in (get_node("../../../../keyboard/buttons_main/GridContainer").get_children() + get_node("../../../../keyboard/buttons_main2/GridContainer2").get_children()):
		#child.normal.bg_color = selected_button_color
		
		for style in style_names:
			var style_box = child.get_child(0).get_theme_stylebox(style)
			var new_style_box = style_box.duplicate()
			new_style_box.bg_color = selected_button_color
			child.get_child(0).add_theme_stylebox_override(style, new_style_box)
		
		var style_box_pressed = child.get_child(0).get_theme_stylebox("pressed")
		var new_style_box_pressed = style_box_pressed.duplicate()
		new_style_box_pressed.bg_color = selected_button_color * 0.5
		child.get_child(0).add_theme_stylebox_override("pressed", new_style_box_pressed)

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func userDeSelected():
	background.color = basic_button_color

#---------------------------------------------------------------------------------------------------

func _on_button_button_up() -> void:
	emit_signal("user_selected", button_number)
