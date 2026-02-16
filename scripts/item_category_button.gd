extends Control

#---------------------------------------------------------------------------------------------------

@export var item_category_id : int
@export var items_array : Array[item_data] = []

signal category_selected(item_category_id)


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _on_button_1_button_up() -> void:
	emit_signal("category_selected", item_category_id)
