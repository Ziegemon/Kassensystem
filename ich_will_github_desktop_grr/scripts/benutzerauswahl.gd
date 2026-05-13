extends Benutzerauswahl_raw
class_name Benutzerauswahl

#---------------------------------------------------------------------------------------------------


@export var user : user_dataQ


#signal user_changed
#signal user_removed

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  


@onready var label_number: Label = $label_number
#@onready var label_name: Label = $label_name
#@onready var label_number_s: Label = $label_number_s


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _ready() -> void:
	background.color = basic_button_color
	label_number.text = str(button_number)
	label_number_s.text = str(button_number)
	
	if user != null:
		user_raw = user
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

#func _on_user_changed() -> void:
	#setupUser()

#---------------------------------------------------------------------------------------------------

#func _on_user_removed() -> void:
	#removeUser()

#---------------------------------------------------------------------------------------------------
