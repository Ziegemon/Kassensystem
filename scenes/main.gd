extends Control

#---------------------------------------------------------------------------------------------------

var current_user : int
var current_selected_user : Benutzerauswahl


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _ready() -> void:
	connectBenutzerauswahlSignals()
	pass

#---------------------------------------------------------------------------------------------------

func _process(delta: float) -> void:
	pass


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func connectBenutzerauswahlSignals():
	for child in $user_selection/MarginContainer/VBoxContainer.get_children():
		child.user_selected.connect(_on_user_selected)

#---------------------------------------------------------------------------------------------------

func _on_user_selected(button_number: int) -> void:
	current_user = button_number
	print("User ausgewählt: ", button_number)

#---------------------------------------------------------------------------------------------------

func activateCurrentuser():
	current_selected_user.removeUser()
	
	current_selected_user = $user_selection/MarginContainer/VBoxContainer.get_child(current_user)
	current_selected_user.setupUser()
