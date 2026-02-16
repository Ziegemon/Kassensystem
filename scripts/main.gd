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
#---------------------------------------------------------------------------------------------------


func _ready() -> void:
	connectBenutzerauswahlSignals()
	current_selected_user = $user_selection/MarginContainer/VBoxContainer.get_child(0)
	current_selected_user.userSelected()
	setUpStatusBar()

#---------------------------------------------------------------------------------------------------

func _process(delta: float) -> void:
	updateClockDate()


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
