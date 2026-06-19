extends Control
class_name Benutzerauswahl_raw

#---------------------------------------------------------------------------------------------------

var user_raw : user_data

@export var button_number : int

@export var selected_button_color : Color
var basic_button_color = Color(0.4, 0.4, 0.4)

var style_names = ["normal", "pressed", "hover", "hover_pressed", "disabled", "focus"]

signal user_selected(button_number)

var last_rechnungslisten_array_index : int = 0

#---------------------------------------------------------------------------------------------------

@onready var background: ColorRect = $background

@export var current_item_list_array : Array[item_data_list_element]

#---------------------------------------------------------------------------------------------------

var rabatt : float = 1.0

var summedUpPrice : float = 0.0

#---------------------------------------------------------------------------------------------------

var user_eft_running : bool = false
var user_eft_failed : bool = false
#var user_eft_ended : bool = false #weg?-------
var user_eft_cancelled : bool = false #---------
var eft_session_id : int = 0 #------------------
var basic_font_color = Color(0.0, 0.0, 0.0)
var eft_font_color = Color(1.0, 0.0, 0.0)
var eft_done_font_color = Color(0.0, 0.463, 0.0)
@onready var label_number_s: Label = $label_number_s
@onready var label_name: Label = $label_name

var zws_background_basic_color = Color(1, 1, 1)
@onready var zws_background = get_tree().root.get_node("MAIN/toolbar_bottom_2/background")

var payment_method_used : int #0 = EC , 1 = BAR , 2 = BAR Offline

@onready var MAIN = get_tree().root.get_node("MAIN")


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
	
	elif user_eft_running == true:
		await get_tree().process_frame
		#await get_tree().create_timer(0.1).timeout
		zws_background.color = eft_font_color
		MAIN.show_summed_up_price_for_running_efts()
	
	else:
		label_number_s.add_theme_color_override("font_color", basic_font_color)
		label_name.add_theme_color_override("font_color", basic_font_color)

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func userDeSelected():
	background.color = basic_button_color

#---------------------------------------------------------------------------------------------------

func _on_button_pressed() -> void:
	emit_signal("user_selected", button_number)

#---------------------------------------------------------------------------------------------------

func startEft(used_payment_method : int):
	eft_session_id += 1
	var this_eft_session_id = eft_session_id
	
	user_eft_running = true
	user_eft_cancelled = false
	payment_method_used = used_payment_method
	
	label_number_s.add_theme_color_override("font_color", eft_font_color)
	label_name.add_theme_color_override("font_color", eft_font_color)
	
	if MAIN.current_user == button_number:
		zws_background.color = eft_font_color #red
	
	#simulation of paymentprocessing due to lack of external ec terminal and cash machine
	var eft_waiting_duration = randi_range(4, 28) #maybe raise back to 40, Grrrr Rentner mit viel Kleingeld --------------------------------
	var elapsed = 0.0
	
	while elapsed < eft_waiting_duration:
		if user_eft_cancelled || this_eft_session_id != eft_session_id:
			cleanUpEft()
			return
		
		await get_tree().create_timer(0.1).timeout
		elapsed += 0.1
	
	if user_eft_cancelled || this_eft_session_id != eft_session_id:
		cleanUpEft()
		return
	
	match  eft_waiting_duration:
		4, 28, 40:
			#await get_tree().create_timer(eft_waiting_duration).timeout
			eftFailed(this_eft_session_id)
		_:
			eftEnded(this_eft_session_id)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

func startEftOffline():
	#if MAIN.current_user == button_number:
			#zws_background.color = eft_done_font_color
	#label_number_s.add_theme_color_override("font_color", eft_done_font_color)
	#label_name.add_theme_color_override("font_color", eft_done_font_color)
	
	eft_session_id += 1
	var this_eft_session_id = eft_session_id
	payment_method_used = 2
	
	eftEnded(this_eft_session_id)
	
	#current_item_list_array.clear()
	#MAIN.updateItemListLabelV3()
	#
	#rabatt = 1.0
	
	eftOfflineCashReturn()
	

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

func eftOfflineCashReturn():
	var current_keyboard_input = MAIN.current_keyboard_input
	var payed_cash : float = 0.0
	#summedUpPrice = MAIN.summ_up_price()
	
	if MAIN.current_user != button_number:
		return
	
	MAIN.label_current_price.hide()
	
	if current_keyboard_input != "0,000":
		payed_cash = snapped(MAIN.keayboardInputToFloat(current_keyboard_input), 0.01)
		MAIN.label_current_price.show()
		MAIN.label_current_price.text = (MAIN.formatPrice(payed_cash - summedUpPrice) + " €")
	
	MAIN._on_button_X_button_pressed(true)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

func eftEnded(session_id: int):
	if session_id != eft_session_id:
		cleanUpEft()
		return
	
	user_eft_running = false
	
	label_number_s.add_theme_color_override("font_color", eft_done_font_color)
	label_name.add_theme_color_override("font_color", eft_done_font_color)
	if MAIN.current_user == button_number:
		zws_background.color = eft_done_font_color
	
	current_item_list_array.clear()
	MAIN.updateItemListLabelV3()
	
	if payment_method_used == 0:
		MAIN.eft_running_EC = false
	elif payment_method_used == 1:
		MAIN.eft_running_BAR = false
	
	rabatt = 1.0
	
	if MAIN.current_user == button_number:
		MAIN.label_current_price.hide()
	
	var newRechnungslistenelement
	if user_raw != null:
		newRechnungslistenelement = rechnungsliste_element.new(user_raw.username, user_raw.user_id, summedUpPrice, payment_method_used) #0 = EC , 1 = BAR , 2 = BAR Offline
	else: #EXTRA user used
		newRechnungslistenelement = rechnungsliste_element.new("EXTRA", 0, summedUpPrice, payment_method_used) #0 = EC , 1 = BAR , 2 = BAR Offline

	SystemData.rechnungsliste.append(newRechnungslistenelement)
	last_rechnungslisten_array_index = (SystemData.rechnungsliste.size() - 1)
	printRechnungAtIndex(last_rechnungslisten_array_index)
	
	await get_tree().create_timer(3).timeout
	if session_id != eft_session_id:
		cleanUpEft()
		return
	
	if MAIN.current_user == button_number:
		label_number_s.add_theme_color_override("font_color", basic_font_color)
		label_name.add_theme_color_override("font_color", basic_font_color)
		zws_background.color = Color(1, 1, 1)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

func eftFailed(session_id: int):
	if session_id != eft_session_id:
		cleanUpEft()
		return
	
	user_eft_running = false
	user_eft_failed = true
	#user_eft_ended = true
	#MAIN.change_zwischensummen_status(false)
	
	#breakEftFailed()
	
	if payment_method_used == 0:
		MAIN.eft_running_EC = false
	else:
		MAIN.eft_running_BAR = false
	
	var eft_failed_blinking_timer = Timer.new()
	eft_failed_blinking_timer.wait_time = 4.0
	eft_failed_blinking_timer.one_shot = true
	add_child(eft_failed_blinking_timer)
	eft_failed_blinking_timer.start()
	
	
	while user_eft_failed == true:
		if session_id != eft_session_id || (eft_failed_blinking_timer.is_stopped() && MAIN.current_user == button_number):
			cleanUpEft()
			return
		
		label_number_s.add_theme_color_override("font_color", eft_font_color) 
		label_name.add_theme_color_override("font_color", eft_font_color)
		if MAIN.current_user == button_number:
			zws_background.color = eft_font_color
		
		await get_tree().create_timer(0.5).timeout
		
		if session_id != eft_session_id || (eft_failed_blinking_timer.is_stopped() && MAIN.current_user == button_number) || user_eft_failed == false:
			cleanUpEft()
			return
		
		label_number_s.add_theme_color_override("font_color", basic_font_color)
		label_name.add_theme_color_override("font_color", basic_font_color)
		if MAIN.current_user == button_number:
			zws_background.color = zws_background_basic_color
		
		await get_tree().create_timer(0.5).timeout
		

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

#func breakEftFailed():
	#await get_tree().create_timer(4).timeout
	#user_eft_ended = false
	#if MAIN.current_user == button_number:
		#user_eft_failed = false
		#user_eft_running = false
		#label_number_s.add_theme_color_override("font_color", basic_font_color)
		#label_name.add_theme_color_override("font_color", basic_font_color)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

func cleanUpEft():
	user_eft_running = false
	user_eft_cancelled = false
	
	label_number_s.add_theme_color_override("font_color", basic_font_color)
	label_name.add_theme_color_override("font_color", basic_font_color)
	if MAIN.current_user == button_number:
		zws_background.color = Color(1, 1, 1)
	
	if payment_method_used == 0:
		MAIN.eft_running_EC = false
	else:
		MAIN.eft_running_BAR = false

#---------------------------------------------------------------------------------------------------

func printRechnungAtIndex(index : int):
	var rl_element = SystemData.rechnungsliste[index]
	actuallyPrintRechnung(rl_element)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

func printRechnungFromRechnungslisteElement(rl_element : rechnungsliste_element):
	actuallyPrintRechnung(rl_element)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

func actuallyPrintRechnung(rl_element : rechnungsliste_element):
	print("--------------------------------")
	
	print("Baäckerei Kasprovicz")
	print("Tel: 08153 / 9527091")
	print("Wörthsee 82237")
	print("Zum Kuckuksheim 3")
	print("")
	print("")
	print("")
	print("")
	print("%02d:%02d:%02d" % [rl_element.time.hour, rl_element.time.minute, rl_element.time.second])
	print("Es bediente Sie: " + rl_element.user_name)
	
	print("--------------------------------")


#print("%02d:%02d:%02d" % [e.time.hour, e.time.minute, e.time.second] + " User: " + e.user_name + " Revenue: " + str(e.revenue))
