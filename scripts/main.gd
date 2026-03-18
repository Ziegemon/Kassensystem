extends Control

#---------------------------------------------------------------------------------------------------

var current_user : int
var current_selected_user : Benutzerauswahl_raw

#---------------------------------------------------------------------------------------------------

@onready var label_user_id: Label = $status_bar/Label_user_id
@onready var label_user_name: Label = $status_bar/Label_user_name
@onready var label_clock: Label = $status_bar/Label_clock
@onready var label_date: Label = $status_bar/Label_date

#---------------------------------------------------------------------------------------------------

var current_keyboard_input : String = "0,000"
var current_keyboard_input_blank : String = "0"
var current_keyboard_input_semicolon : String
var zwischensumme : bool = false
@onready var label_current_price: Label = $displays/display_money/Label_current_price
var semicolon_pressed : bool = false

@onready var label_items_quantity_weight: Label = $displays/display_items/Label_items_quantity_weight
@onready var label_items_names: Label = $displays/display_items/Label_items_names
@onready var label_items_price: Label = $displays/display_items/Label_items_price



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
	
	setUpDisplayLabels()

#---------------------------------------------------------------------------------------------------

func _process(delta: float) -> void:
	updateClockDate()
	label_current_price.text = current_keyboard_input
	#updateKeyboardInput()


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
	updateItemListLabel()

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
	zwischensumme = false

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func createNewItemDataListElement(item: item_data):
	var new_element = item_data_list_element.new()
	new_element.item = item
	
	if item.wiegeprodukt == false:
		new_element.weight = 0.0
		if current_keyboard_input == "0,000":
			new_element.quantity = 1
		else:
			new_element.quantity = clamp(keayboardInoutToFloat(current_keyboard_input), 1, 999)
	else:
		new_element.quantity = 1
		new_element.weight = clamp(keayboardInoutToFloat(current_keyboard_input), 0.001, 999.999)
	
	if !(item.wiegeprodukt == true && keayboardInoutToFloat(current_keyboard_input) == 0.0): #not added to item lsit if is wiegeprodukt but no number/weight was entered
		current_selected_user.current_item_list_array.append(new_element)
	
		resetKeyboardInput()
		updateItemListLabel()

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func keayboardInoutToFloat(text : String) -> float:
	return text.replace(",", ".").to_float()

#---------------------------------------------------------------------------------------------------

func connectKeyboardButtonsSignals():
	for child in ($keyboard/buttons_main/GridContainer.get_children() + $keyboard/buttons_main2/GridContainer2.get_children()):
		if child.has_signal("keyboard_button_pressed"):
			child.keyboard_button_pressed.connect(_on_keyboard_button_pressed)

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

#shows the pressed buttons from the keyboard on the label_current_price
func _on_keyboard_button_pressed(button_number: int, button_semicolon : bool) -> void:
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
		
		if getDecimalCount(current_keyboard_input) == 2: #ensures there are always the decimals after the semicolon
			current_keyboard_input += "0"
		elif getDecimalCount(current_keyboard_input) < 2:
			current_keyboard_input += "00"

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func getDecimalCount(text : String) -> int:
	if !text.contains(","):
		return 0
	else:
		return text.split(",")[1].length()

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

#func updateKeyboardInput():
	#if current_keyboard_input == 0.0 && zwischensumme == false && show_label_current_price_nevertheless == false:
		#label_current_price.hide()
	#else:
		#label_current_price.show()

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

func resetKeyboardInput():
	current_keyboard_input = "0,000"
	current_keyboard_input_blank = "0"
	current_keyboard_input_semicolon = ""
	semicolon_pressed = false
	label_current_price.hide()

#---------------------------------------------------------------------------------------------------

func updateItemListLabel():
	var lines_names : Array[String]
	
	for e in current_selected_user.current_item_list_array:
		var line : String = e.item.name
		lines_names.append(line)
	
	label_items_names.text = "\n".join(lines_names)
	
	#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
	
	var lines_quantity_weigth : Array[String]
	
	for e in current_selected_user.current_item_list_array:
		var line : String
		if e.item.wiegeprodukt == false:
			line = (str(e.quantity).replace(".", ",") + " x")
		else:
			line = (str(e.weight).replace(".", ",") + " kg")
			
		lines_quantity_weigth.append(line)
	
	label_items_quantity_weight.text = "\n".join(lines_quantity_weigth)
	
	#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
	
	var lines_price : Array[String]
	
	for e in current_selected_user.current_item_list_array:
		var line : String
		if e.item.wiegeprodukt == false:
			line = (formatPrice(e.item.price * e.quantity) + " €")
		else:
			line = (formatPrice(e.item.price * e.weight) + " €")
		
		lines_price.append(line)
	
	label_items_price.text = "\n".join(lines_price)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func formatPrice(price : float) -> String:
	return ("%.2f" % price).replace(".", ",")
	#return ("%.2f" % price).to_float()

#---------------------------------------------------------------------------------------------------

func setUpDisplayLabels():
	#label_items_quantity_weight.hide()
	#label_items_names.hide()
	#label_items_price.hide()
	
	label_items_quantity_weight.text = ""
	label_items_names.text = ""
	label_items_price.text = ""

#---------------------------------------------------------------------------------------------------

func _on_button_ZWS_button_up() -> void:
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
	updateItemListLabel()
