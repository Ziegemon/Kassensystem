extends HBoxContainer


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _on_reset_button_pressed() -> void:
	get_tree().get_root().get_node("Main").set_n_apply_rabatt(0)
	_on_return_button_pressed()
	_on_return_button_pressed()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func _on_5_button_pressed() -> void:
	get_tree().get_root().get_node("Main").set_n_apply_rabatt(0.05)
	_on_return_button_pressed()
	_on_return_button_pressed()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func _on_10_button_pressed() -> void:
	get_tree().get_root().get_node("Main").set_n_apply_rabatt(0.10)
	_on_return_button_pressed()
	_on_return_button_pressed()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func _on_15_button_pressed() -> void:
	get_tree().get_root().get_node("Main").set_n_apply_rabatt(0.15)
	_on_return_button_pressed()
	_on_return_button_pressed()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func _on_25_button_pressed() -> void:
	get_tree().get_root().get_node("Main").set_n_apply_rabatt(0.25)
	_on_return_button_pressed()
	_on_return_button_pressed()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func _on_50_button_pressed() -> void:
	get_tree().get_root().get_node("Main").set_n_apply_rabatt(0.50)
	_on_return_button_pressed()
	_on_return_button_pressed()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func _on_return_button_pressed() -> void:
	get_tree().get_root().get_node("Main/toolbar_bottom_1/MarginContainer/Rabatt_HBoxContainer").hide()
	get_tree().get_root().get_node("Main/toolbar_bottom_1/MarginContainer/HBoxContainer").show()
