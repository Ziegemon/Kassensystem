extends Benutzerauswahl_raw
class_name Benutzerauswahl

#---------------------------------------------------------------------------------------------------


@export var user : user_data


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
	
	user = null
	user_raw = null

#---------------------------------------------------------------------------------------------------

#func _on_user_changed() -> void:
	#setupUser()

#---------------------------------------------------------------------------------------------------

#func _on_user_removed() -> void:
	#removeUser()

#---------------------------------------------------------------------------------------------------

func logInUser(user_id : int):
	var path := "res://data/users/%d.tres" % user_id
	
	get_tree().get_root().get_node("MAIN").user_login_id = 0
	
	var vBoxChildren = get_tree().get_root().get_node("MAIN/user_selection/MarginContainer/VBoxContainer").get_children()
	for e in range(vBoxChildren.size() - 1):
		if vBoxChildren[e].user == ResourceLoader.load(path):
			return
	
	if !(ResourceLoader.exists(path)):
		return
	
	elif user == null:
		user = ResourceLoader.load(path)
		user_raw = ResourceLoader.load(path)
		get_tree().get_root().get_node("MAIN").activateCurrentuser()
		setupUser()
	
	#zeoiterfassung???????????-------------------------

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func logOutUser():
	removeUser()
	get_tree().get_root().get_node("MAIN").activateCurrentuser()
#
