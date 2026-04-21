extends Control
class_name Benutzerauswahl_raw

#---------------------------------------------------------------------------------------------------

@export var button_number : int

@export var selected_button_color : Color
var basic_button_color = Color(0.4, 0.4, 0.4)

var style_names = ["normal", "pressed", "hover", "hover_pressed", "disabled", "focus"]

signal user_selected(button_number)

#---------------------------------------------------------------------------------------------------

@onready var background: ColorRect = $background

@export var current_item_list_array : Array[item_data_list_element]

#---------------------------------------------------------------------------------------------------

var rabatt : float = 1.0

#---------------------------------------------------------------------------------------------------

var user_eft_running : bool = false
var user_eft_failed : bool = false
var user_eft_ended : bool = false
var basic_font_color = Color(0.0, 0.0, 0.0)
var eft_font_color = Color(1.0, 0.0, 0.0)
var eft_done_font_color = Color(0.0, 0.463, 0.0)
@onready var label_number_s: Label = $label_number_s
@onready var label_name: Label = $label_name

var zws_background_basic_color = Color(1, 1, 1)
@onready var zws_background = get_tree().root.get_node("MAIN/toolbar_bottom_2/background")

var payment_method_used : int #0 = EC & 1 = BAR


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
	
	if user_eft_failed == true:
		user_eft_failed = false
		user_eft_running = false
		
	elif user_eft_ended == true:
		user_eft_ended = false
		label_number_s.add_theme_color_override("font_color", basic_font_color)
		label_name.add_theme_color_override("font_color", basic_font_color)
		
		if payment_method_used == 0:
			get_tree().root.get_node("MAIN").eft_running_EC = false
		else:
			get_tree().root.get_node("MAIN").eft_running_BAR = false
	
	elif user_eft_running:
		await get_tree().create_timer(0.1).timeout
		zws_background.color = eft_font_color
		get_tree().root.get_node("MAIN").show_summed_up_price_for_running_efts()

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func userDeSelected():
	background.color = basic_button_color

#---------------------------------------------------------------------------------------------------

func _on_button_button_up() -> void:
	emit_signal("user_selected", button_number)

#---------------------------------------------------------------------------------------------------

func startEft(used_payment_method : int):
	user_eft_running = true
	payment_method_used = used_payment_method
	label_number_s.add_theme_color_override("font_color", eft_font_color)
	label_name.add_theme_color_override("font_color", eft_font_color)
	
	if get_tree().root.get_node("MAIN").current_user == button_number:
			zws_background.color = eft_font_color
	
	#simulation of paymentprocessing due to lack of external ec terminal and cash machiene
	var eft_waiting_duration = randi_range(4, 28)
	match  eft_waiting_duration:
		28, 40:
			await get_tree().create_timer(eft_waiting_duration).timeout
			eftFailed()
		_:
			await get_tree().create_timer(eft_waiting_duration).timeout
			eftEnded()

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func eftEnded():
	user_eft_ended = true
	user_eft_running = false
	label_number_s.add_theme_color_override("font_color", eft_done_font_color)
	label_name.add_theme_color_override("font_color", eft_done_font_color)
	if get_tree().root.get_node("MAIN").current_user == button_number:
			zws_background.color = eft_done_font_color
	current_item_list_array.clear()
	get_tree().root.get_node("MAIN").updateItemListLabelV3()
	
	if payment_method_used == 0:
		get_tree().root.get_node("MAIN").eft_running_EC = false
	else:
		get_tree().root.get_node("MAIN").eft_running_BAR = false
	
	rabatt = 1.0
	
	await get_tree().create_timer(5).timeout
	if get_tree().root.get_node("MAIN").current_user == button_number:
		user_eft_ended = false
		label_number_s.add_theme_color_override("font_color", basic_font_color)
		label_name.add_theme_color_override("font_color", basic_font_color)
	
	

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func eftFailed():
	user_eft_failed = true
	#get_tree().root.get_node("MAIN").change_zwischensummen_status(false)
	breakEftFailed()
	
	if payment_method_used == 0:
		get_tree().root.get_node("MAIN").eft_running_EC = false
	else:
		get_tree().root.get_node("MAIN").eft_running_BAR = false
	
	while user_eft_running == true:
		label_number_s.add_theme_color_override("font_color", eft_font_color)
		label_name.add_theme_color_override("font_color", eft_font_color)
		if get_tree().root.get_node("MAIN").current_user == button_number:
			zws_background.color = eft_font_color
		
		await get_tree().create_timer(0.5).timeout
		
		label_number_s.add_theme_color_override("font_color", basic_font_color)
		label_name.add_theme_color_override("font_color", basic_font_color)
		if get_tree().root.get_node("MAIN").current_user == button_number:
			zws_background.color = zws_background_basic_color
		
		await get_tree().create_timer(0.5).timeout

#-    -    -    -    -    -    -    -    -    -    -    -    -    -    -    -    -    -    -    - 

func breakEftFailed():
	await get_tree().create_timer(7).timeout
	if get_tree().root.get_node("MAIN").current_user == button_number:
		user_eft_failed = false
		user_eft_running = false
		label_number_s.add_theme_color_override("font_color", basic_font_color)
		label_name.add_theme_color_override("font_color", basic_font_color)
