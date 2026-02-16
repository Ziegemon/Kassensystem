extends Control

#---------------------------------------------------------------------------------------------------

var current_user : int
var current_selected_user : Benutzerauswahl_raw


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _ready() -> void:
	connectBenutzerauswahlSignals()
	current_selected_user = $user_selection/MarginContainer/VBoxContainer.get_child(0)
	current_selected_user.userSelected()
	setUpStatusBar()

#---------------------------------------------------------------------------------------------------

#func _process(delta: float) -> void:
	#pass


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func connectBenutzerauswahlSignals():
	for child in $user_selection/MarginContainer/VBoxContainer.get_children():
		if child.has_signal("user_selected"):
			child.user_selected.connect(_on_user_selected)

#---------------------------------------------------------------------------------------------------

func _on_user_selected(button_number: int) -> void:
	current_user = button_number
	activateCurrentuser()
	#print("User ausgewählt: ", button_number)

#---------------------------------------------------------------------------------------------------

func activateCurrentuser():
	if current_selected_user != null:
		current_selected_user.userDeSelected()
	
	current_selected_user = $user_selection/MarginContainer/VBoxContainer.get_child(current_user - 1)
	current_selected_user.userSelected()
	
	if current_selected_user is Benutzerauswahl && current_selected_user.user != null:
		$status_bar/Label_user_id.text = str(current_selected_user.user.user_id)
		$status_bar/Label_user_name.text = str(current_selected_user.user.username)
	elif current_selected_user is Benutzerauswahl_extra:
		$status_bar/Label_user_id.text = "X"
		$status_bar/Label_user_name.text = "EXTRA"
	else:
		$status_bar/Label_user_id.text = "X"
		$status_bar/Label_user_name.text = "______________________"

#---------------------------------------------------------------------------------------------------

func setUpStatusBar():
	if current_selected_user is Benutzerauswahl && current_selected_user.user != null:
		$status_bar/Label_user_id.text = str(current_selected_user.user.user_id)
		$status_bar/Label_user_name.text = str(current_selected_user.user.username)
	elif current_selected_user is Benutzerauswahl_extra:
		$status_bar/Label_user_id.text = "X"
		$status_bar/Label_user_name.text = "EXTRA"
	else:
		$status_bar/Label_user_id.text = "X"
		$status_bar/Label_user_name.text = "______________________"
