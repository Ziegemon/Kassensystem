extends Control
class_name display_item_element

@onready var label_items_quantity_weight: Label = $Label_items_quantity_weight
@onready var label_items_names: Label = $Label_items_names
@onready var label_items_price: Label = $Label_items_price

var item_list_element : item_data_list_element
var item_list_element_id : int

signal display_item_element_button_transmit_id(button_id : int)


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


#func _init(item : item_data_list_element) -> void:
	#item_list_element = item
#
#func _ready() -> void:
	#setUpItemListElement(item_list_element)


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func setUpItemListElement(item : item_data_list_element, button_id : int):
	item_list_element = item
	
	label_items_names.text = item.item.name
	
	if item.weight == 0.0:
		label_items_quantity_weight.text = (str(item.quantity).replace(".", ",") + " x")
	else:
		label_items_quantity_weight.text = (str(item.weight).replace(".", ",") + " kg")
	
	if item.weight == 0.0:
		label_items_price.text = (formatPrice(item.item.price * item.quantity) + " €")
	else:
		label_items_price.text = (formatPrice(item.item.price * item.weight) + " €")
	
	item_list_element_id = button_id

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func formatPrice(price : float) -> String:
	return ("%.2f" % price).replace(".", ",")

#---------------------------------------------------------------------------------------------------

func _on_display_item_element_button_pressed() -> void:
	emit_signal("display_item_element_button_transmit_id", item_list_element_id)
	print(item_list_element_id)

#---------------------------------------------------------------------------------------------------

func highlightOn():
	pass
