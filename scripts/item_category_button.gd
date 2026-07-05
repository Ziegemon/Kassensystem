extends Control

#---------------------------------------------------------------------------------------------------

@export var item_category_id : int
@export var item_category_name : String
@export var items_array : Array[item_data] = []

@export var is_just_button : bool = false

signal category_selected(item_category_id)


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _ready() -> void:
	$Button.text = item_category_name


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _on_button_pressed() -> void:
	emit_signal("category_selected", item_category_id)
