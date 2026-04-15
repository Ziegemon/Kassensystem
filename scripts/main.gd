extends Control

#---------------------------------------------------------------------------------------------------

var current_user : int
var current_selected_user : Benutzerauswahl_raw

#---------------------------------------------------------------------------------------------------

@onready var label_user_id: Label = $status_bar/Label_user_id
@onready var label_user_name: Label = $status_bar/Label_user_name
@onready var label_clock: Label = $status_bar/Label_clock
@onready var label_date: Label = $status_bar/Label_date
@onready var label_rabatt: Label = $status_bar/Label_rabatt


#---------------------------------------------------------------------------------------------------

var current_keyboard_input : String = "0,000"
var current_keyboard_input_blank : String = "0"
var current_keyboard_input_semicolon : String
var zwischensumme : bool = false
@onready var label_current_price: Label = $displays/display_money/Label_current_price
var semicolon_pressed : bool = false

#---------------------------------------------------------------------------------------------------

@onready var labels_items_scroll_container_vbox_container: VBoxContainer = $displays/display_items/Labels_items_VScrollContainer/VBoxContainer
@onready var labels_items_v_scroll_container: ScrollContainer = $displays/display_items/Labels_items_VScrollContainer

var current_selcted_item_list_item : int = -1

#---------------------------------------------------------------------------------------------------

var etf_running_EC : bool = false
var etf_running_BAR : bool = false


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _ready() -> void:
	connectBenutzerauswahlSignals()
	current_selected_user = $user_selection/MarginContainer/VBoxContainer.get_child(0)
	current_selected_user.userSelected()
	setUpStatusBar()
	
	connectItemCategorylSignals()
	loadCategoryItems(0)
	
	connectItemButtonSignals()
	
	connectKeyboardButtonsSignals()
	resetKeyboardInput()
	
	label_rabatt.hide()

#---------------------------------------------------------------------------------------------------

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	updateClockDate()


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func connectBenutzerauswahlSignals():
	for child in $user_selection/MarginContainer/VBoxContainer.get_children():
		if child.has_signal("user_selected"):
			child.user_selected.connect(_on_user_selected)

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func _on_user_selected(button_number: int) -> void:
	current_user = button_number
	activateCurrentuser()
	resetKeyboardInput()
	loadCategoryItems(0)
	updateItemListLabelV3()
	
	if current_selected_user.rabatt == 1.0:
		label_rabatt.hide()
	else:
		label_rabatt.show()

#---------------------------------------------------------------------------------------------------

func activateCurrentuser():
	if current_selected_user != null:
		current_selected_user.userDeSelected()
	
	current_selected_user = $user_selection/MarginContainer/VBoxContainer.get_child(current_user - 1)
	current_selected_user.userSelected()
	
	if current_selected_user is Benutzerauswahl && current_selected_user.user != null:
		label_user_id.text = str(current_selected_user.user.user_id)
		label_user_name.text = str(current_selected_user.user.username)
	elif current_selected_user is Benutzerauswahl_extra:
		label_user_id.text = "X"
		label_user_name.text = "EXTRA"
	else:
		label_user_id.text = "X"
		label_user_name.text = "__________________"
	
	change_zwischensummen_status(false)

#---------------------------------------------------------------------------------------------------

func setUpStatusBar():
	if current_selected_user is Benutzerauswahl && current_selected_user.user != null:
		label_user_id.text = str(current_selected_user.user.user_id)
		label_user_name.text = str(current_selected_user.user.username)
	elif current_selected_user is Benutzerauswahl_extra:
		label_user_id.text = "X"
		label_user_name.text = "EXTRA"
	else:
		label_user_id.text = "X"
		label_user_name.text = "__________________"

#---------------------------------------------------------------------------------------------------

func updateClockDate():
	var t = Time.get_time_dict_from_system()
	label_clock.text = "%02d:%02d" % [t.hour, t.minute]
	
	var d = Time.get_date_dict_from_system()
	label_date.text = "%02d.%02d.%04d" % [d.day, d.month, d.year]

#---------------------------------------------------------------------------------------------------

func connectItemCategorylSignals():
	for child in $item_categories/MarginContainer/GridContainer.get_children():
		if child.has_signal("category_selected"):
			child.category_selected.connect(_on_category_selected)

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func _on_category_selected(item_category_id: int) -> void:
	loadCategoryItems(item_category_id)

#---------------------------------------------------------------------------------------------------

func loadCategoryItems(item_category_id: int):
	clearItemButtons()
	
	var item_array = $item_categories/MarginContainer/GridContainer.get_child(item_category_id).items_array
	
	
	for i in range(item_array.size()):
		$items/MarginContainer/GridContainer.get_child(i).button_item_data = item_array[i]

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func clearItemButtons():
	for y in range($items/MarginContainer/GridContainer.get_child_count()):
		$items/MarginContainer/GridContainer.get_child(y).button_item_data = null
	

#---------------------------------------------------------------------------------------------------

func connectItemButtonSignals():
	for child in $items/MarginContainer/GridContainer.get_children():
		if child.has_signal("item_button_pressed"):
			child.item_button_pressed.connect(_on_item_button_pressed)

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func _on_item_button_pressed(button_item_data: item_data) -> void:
	if !(current_selected_user is Benutzerauswahl_extra) && current_selected_user.user != null:
		createNewItemDataListElement(button_item_data)
	elif current_selected_user is Benutzerauswahl_extra:
		createNewItemDataListElement(button_item_data)
	change_zwischensummen_status(false)

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func createNewItemDataListElement(item: item_data):
	var new_element = item_data_list_element.new()
	new_element.item = item
	
	if item.wiegeprodukt == false:
		new_element.weight = 0.0
		if current_keyboard_input == "0,000":
			new_element.quantity = 1
		else:
			new_element.quantity = clamp(keayboardInputToFloat(current_keyboard_input), 1, 999)
	else:
		new_element.quantity = 1
		new_element.weight = clamp(keayboardInputToFloat(current_keyboard_input), 0.001, 999.999)
	
	if !(item.wiegeprodukt == true && keayboardInputToFloat(current_keyboard_input) == 0.0): #not added to item lsit if is wiegeprodukt but no number/weight was entered
		current_selected_user.current_item_list_array.append(new_element)
	
		resetKeyboardInput()
		setLabelCurrentPrice()
		addItemToList(new_element)

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func keayboardInputToFloat(text : String) -> float:
	return text.replace(",", ".").to_float()

#---------------------------------------------------------------------------------------------------

func setLabelCurrentPrice():
	var element = current_selected_user.current_item_list_array[current_selected_user.current_item_list_array.size() - 1]
	var line : String
	if element.item.wiegeprodukt == false:
		line = (formatPrice(element.item.price * element.quantity * current_selected_user.rabatt) + " €")
	else:
		line = (formatPrice(element.item.price * element.weight * current_selected_user.rabatt) + " €")
	
	label_current_price.text = line
	label_current_price.show()

#---------------------------------------------------------------------------------------------------

func connectKeyboardButtonsSignals():
	for child in ($keyboard/buttons_main/GridContainer.get_children() + $keyboard/buttons_main2/GridContainer2.get_children()):
		if child.has_signal("keyboard_button_pressed"):
			child.keyboard_button_pressed.connect(_on_keyboard_button_pressed)

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

#shows the pressed buttons from the keyboard on the label_current_price
func _on_keyboard_button_pressed(button_number: int, button_semicolon : bool) -> void:
	if current_selected_user.user_etf_running == true:
		return
	
	if current_selected_user.user == null:
		return
	
	label_current_price.show()
	
	if button_semicolon == true && semicolon_pressed == false: #semicolon just got pressed for the first tim -> new numbers are now added after the semicolon
		current_keyboard_input_semicolon = (current_keyboard_input_blank + ",")
		semicolon_pressed = true
		if current_keyboard_input == "0,000":
			current_keyboard_input = "0," 
	
	
	if current_keyboard_input == "0,000": #if the label is "empty", the clicked button replaces the 0
		current_keyboard_input = (str(button_number) + ",000")
		current_keyboard_input_blank = str(button_number)
		
	elif semicolon_pressed == false: #there already is a number =/= 0 -> new number is added behind it but before the semicolon
		current_keyboard_input = (current_keyboard_input_blank + str(button_number) + ",000")
		current_keyboard_input_blank += str(button_number)
		
	elif button_semicolon == false && getDecimalCount(current_keyboard_input_semicolon) < 3: #semicolon has been pressed and there are less then 2 decimals -> number added after semicolon/ number after semicolon
		current_keyboard_input = (current_keyboard_input_semicolon + str(button_number))
		current_keyboard_input_semicolon += str(button_number)
	
	change_zwischensummen_status(false)
	
	label_current_price.text = current_keyboard_input

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func getDecimalCount(text : String) -> int:
	if !text.contains(","):
		return 0
	else:
		return text.split(",")[1].length()

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func resetKeyboardInput():
	current_keyboard_input = "0,000"
	current_keyboard_input_blank = "0"
	current_keyboard_input_semicolon = ""
	semicolon_pressed = false
	label_current_price.hide()

#---------------------------------------------------------------------------------------------------

func formatPrice(price : float) -> String:
	return ("%.2f" % price).replace(".", ",")
	#return ("%.2f" % price).to_float()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


func addItemToList(item: item_data_list_element):
	var new_display_item_element = preload("uid://ba6pnhi1gmmx4").instantiate()
	labels_items_scroll_container_vbox_container.add_child(new_display_item_element)
	new_display_item_element.setUpItemListElement(item, labels_items_scroll_container_vbox_container.get_child_count() - 1)
	new_display_item_element.display_item_element_button_transmit_id.connect(_on_display_item_element_button_transmit_id)
	
	await get_tree().create_timer(0.005).timeout
	@warning_ignore("narrowing_conversion")
	labels_items_v_scroll_container.scroll_vertical = labels_items_v_scroll_container.get_v_scroll_bar().max_value
	
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func _on_display_item_element_button_transmit_id(button_id : int):
	for e in labels_items_scroll_container_vbox_container.get_children():
		e.get_child(0).button_pressed = false
	
	labels_items_scroll_container_vbox_container.get_child(button_id).get_child(0).button_pressed = true #!!!!!!!!!!!!!!!!!!!!!!!!!kann get_child(button_id) bleiben, wenn die button_ids nach KOrrektur neu zugewiesenw erden
	current_selcted_item_list_item = button_id

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func updateItemListLabelV3():
	for child in labels_items_scroll_container_vbox_container.get_children():
		child.queue_free()
	await get_tree().process_frame
	
	for e in range(current_selected_user.current_item_list_array.size()):
		var new_display_item_element = preload("uid://ba6pnhi1gmmx4").instantiate()
		labels_items_scroll_container_vbox_container.add_child(new_display_item_element)
		new_display_item_element.setUpItemListElement(current_selected_user.current_item_list_array[e], e)
		new_display_item_element.display_item_element_button_transmit_id.connect(_on_display_item_element_button_transmit_id)

#---------------------------------------------------------------------------------------------------

func _on_button_ZWS_button_up() -> void:
	if current_selected_user.user_etf_running == true:
		return
		
	var temp_new_item_list_array : Array[item_data_list_element]
	var temp_item_ids_in_for_new_array : Array[int]
	
	#every id from current_selected_user.current_item_list_array gets added to temp_item_ids_in_for_new_array once, wiegeprodukte are showen directly
	for e in current_selected_user.current_item_list_array:
		if e.item.item_id not in temp_item_ids_in_for_new_array && e.item.wiegeprodukt == false:
			temp_item_ids_in_for_new_array.append(e.item.item_id)
		elif e.item.wiegeprodukt == true:
			temp_new_item_list_array.append(e)
	
	#for every id in temp_item_ids_in_for_new_array, the quantity of all objects with this id in current_selected_user.current_item_list_array are summed up, amde into a new object and get appended to the new sorted array
	for i in temp_item_ids_in_for_new_array:
		var summed_up_item_quantity : int = 0
		var new_item_data_list_element = item_data_list_element.new()
		var item_already_set : bool = false
		
		for e in current_selected_user.current_item_list_array:
			if e.item.item_id == i:
				summed_up_item_quantity += e.quantity
			
				if item_already_set == false:
					new_item_data_list_element.item = e.item
					item_already_set = true
			
		new_item_data_list_element.quantity = summed_up_item_quantity
		temp_new_item_list_array.append(new_item_data_list_element)
	
	current_selected_user.current_item_list_array = temp_new_item_list_array
	updateItemListLabelV3()
	change_zwischensummen_status(true)
	
	await get_tree().create_timer(0.005).timeout
	@warning_ignore("narrowing_conversion")
	labels_items_v_scroll_container.scroll_vertical = labels_items_v_scroll_container.get_v_scroll_bar().max_value

#---------------------------------------------------------------------------------------------------

func change_zwischensummen_status(zws_status : bool):
	zwischensumme = zws_status
	
	var summedUpPrice : float = 0
	
	for e in current_selected_user.current_item_list_array:
		if e.item.wiegeprodukt == false:
			summedUpPrice += (e.item.price * e.quantity)
		else:
			summedUpPrice += (e.item.price * e.weight)
	
	if zwischensumme == true && summedUpPrice > 0.000:
		#$toolbar_bottom_2/background.color = Color(0.0, 0.611, 0.0)
		$toolbar_bottom_2/background.color = Color(0.678, 1.0, 0.655)
		
		label_current_price.text = (formatPrice(summedUpPrice * current_selected_user.rabatt) + " €")
		label_current_price.show()
		
	else:
		$toolbar_bottom_2/background.color = Color(1, 1, 1)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func show_summed_up_price_for_running_etfs():
	var summedUpPrice : float = 0
	
	for e in current_selected_user.current_item_list_array:
		if e.item.wiegeprodukt == false:
			summedUpPrice += (e.item.price * e.quantity)
		else:
			summedUpPrice += (e.item.price * e.weight)
		
		label_current_price.text = (formatPrice(summedUpPrice * current_selected_user.rabatt) + " €")
		label_current_price.show()
	

#---------------------------------------------------------------------------------------------------

func _on_button_X_button_up() -> void:
	current_keyboard_input = "0,000"
	label_current_price.text = ""

#---------------------------------------------------------------------------------------------------
 
func _on_korrektur_button_button_up() -> void:
	if current_selcted_item_list_item == -1: #no item in array selected
		var last_element_in_array = current_selected_user.current_item_list_array[current_selected_user.current_item_list_array.size() - 1]
		
		if (last_element_in_array.weight == 0.000 && keayboardInputToFloat(current_keyboard_input) != 0.000): #if item != wiegeprodukt -= reduces entered quantity
			if last_element_in_array.quantity - clamp(keayboardInputToFloat(current_keyboard_input), 1, 999) <= 0:
				current_selected_user.current_item_list_array.remove_at(current_selected_user.current_item_list_array.size() - 1) #removes last added item
			else:
				last_element_in_array.quantity -= clamp(keayboardInputToFloat(current_keyboard_input), 1, 999)
		
		elif (last_element_in_array.weight != 0.000 && keayboardInputToFloat(current_keyboard_input) != 0.000): #if item == wiegeprodukt -> reduces weight
			if last_element_in_array.weight - clamp(keayboardInputToFloat(current_keyboard_input), 0.001, 999.999) <= 0:
				current_selected_user.current_item_list_array.remove_at(current_selected_user.current_item_list_array.size() - 1) #removes last added item
			else:
				last_element_in_array.weight -= clamp(keayboardInputToFloat(current_keyboard_input), 0.001, 999.999)
		
		else:
			current_selected_user.current_item_list_array.remove_at(current_selected_user.current_item_list_array.size() - 1) #removes last added item
		
	else: #an item in the array is selected
		var  seleceted_item_in_array = current_selected_user.current_item_list_array[current_selcted_item_list_item]
		
		if (seleceted_item_in_array.weight == 0.000 && keayboardInputToFloat(current_keyboard_input) != 0.000): #if item != wiegeprodukt -= reduces entered quantity
			if seleceted_item_in_array.quantity - clamp(keayboardInputToFloat(current_keyboard_input), 1, 999) <= 0:
				current_selected_user.current_item_list_array.remove_at(current_selcted_item_list_item) #removes selected item
			else:
				seleceted_item_in_array.quantity -= clamp(keayboardInputToFloat(current_keyboard_input), 1, 999)
		
		elif (seleceted_item_in_array.weight != 0.000 && keayboardInputToFloat(current_keyboard_input) != 0.000): #if item == wiegeprodukt -> reduces weight
			if seleceted_item_in_array.weight - clamp(keayboardInputToFloat(current_keyboard_input), 0.001, 999.999) <= 0:
				current_selected_user.current_item_list_array.remove_at(current_selcted_item_list_item) #removes selected item
			else:
				seleceted_item_in_array.weight -= clamp(keayboardInputToFloat(current_keyboard_input), 0.001, 999.999)
		
		else:
			current_selected_user.current_item_list_array.remove_at(current_selcted_item_list_item)
	
	current_selcted_item_list_item = -1
	
	updateItemListLabelV3()
	change_zwischensummen_status(false)
	resetKeyboardInput()
	label_current_price.text = ""

#---------------------------------------------------------------------------------------------------

func _on_rabatt_button_pressed() -> void:
	if current_selected_user.user_etf_running == true:
		return
	
	$toolbar_bottom_1/MarginContainer/Rabatt_HBoxContainer.show()
	$toolbar_bottom_1/MarginContainer/HBoxContainer.hide()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func set_n_apply_rabatt(new_rabatt : float):
	current_selected_user.rabatt = clamp(1 - new_rabatt, 0.0, 1.0)
	label_rabatt.text = "Rabatt: " + str(int(new_rabatt * 100)) + "%"
	
	if new_rabatt == 0.0:
		label_rabatt.hide()
	else:
		label_rabatt.show()
		
	label_current_price.text = ""
	
	updateItemListLabelV3()
	
	change_zwischensummen_status(false)


#---------------------------------------------------------------------------------------------------

func _on_ec_button_button_up() -> void:
	if zwischensumme == true && etf_running_EC == false:
		change_zwischensummen_status(false)
		etf_running_EC = true
		current_selected_user.startEtf(0)
	elif etf_running_EC == true:
		errorEtfEcAlreadyInUse()
	else:
		errorNoZws()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func _on_bar_button_button_up() -> void:
	if zwischensumme == true && etf_running_BAR == false:
		change_zwischensummen_status(false)
		etf_running_BAR = true
		current_selected_user.startEtf(1)
	elif etf_running_BAR == true:
		errorEtfBarAlreadyInUse()
	else:
		errorNoZws()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func errorNoZws():
	pass

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func errorEtfEcAlreadyInUse():
	pass

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func errorEtfBarAlreadyInUse():
	pass
