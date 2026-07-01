extends Benutzerauswahl_raw
class_name Benutzerauswahl

#---------------------------------------------------------------------------------------------------


@export var user : user_data
var zeiterfassungs_status : bool = false 
var zeiterfassung_currently_active : bool = false

#signal user_changed
#signal user_removed

#-  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  


@onready var label_number: Label = $label_number
#@onready var label_name: Label = $label_name
#@onready var label_number_s: Label = $label_number_s


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	zeiterfassung()


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
	
	zeiterfassungs_status = true

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
	
	zeiterfassung_currently_active = false
	zeiterfassungs_status = true

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func logOutUser():
	abmeldungs_message()
	removeUser()
	get_tree().get_root().get_node("MAIN").activateCurrentuser()
	zeiterfassung_currently_active = false

#---------------------------------------------------------------------------------------------------

func printLastRechnung():
	var this_users_rechnungen : Array[rechnungsliste_element] = []
	
	for e in SystemData.rechnungsliste:
		if e.user_id == user.user_id:
			this_users_rechnungen.append(e)
	
	if this_users_rechnungen.size() > 0:
		printRechnungFromRechnungslisteElement(this_users_rechnungen[this_users_rechnungen.size() - 1])

#---------------------------------------------------------------------------------------------------

func zeiterfassung():
	if zeiterfassung_currently_active == true:
		return
	
	zeiterfassung_currently_active = true
	
	if user == null:
		return
		
	var current_arbeitszeit_data = get_todays_arbeitszeit_data()
	
	
	
	#for e in user.arbeitszeit_datas:
		#if e.date == Time.get_date_dict_from_system():
			#current_arbeitszeit_data = e
			#break
	
	if current_arbeitszeit_data == null:
		var new_arbeitszeit_data = arbeitszeit_data.new(Time.get_date_dict_from_system())
		user.arbeitszeit_datas.append(new_arbeitszeit_data)
		current_arbeitszeit_data = user.arbeitszeit_datas[(user.arbeitszeit_datas.size() -1)]

	while zeiterfassungs_status == true:
		await get_tree().create_timer(1).timeout
		current_arbeitszeit_data.time += (1.0/60.0)
	
	zeiterfassung_currently_active = false

#---------------------------------------------------------------------------------------------------

func abmeldungs_message():
	var current_arbeitszeit_data = get_todays_arbeitszeit_data()
	
	#for e in user.arbeitszeit_datas:
		#if e.date == Time.get_date_dict_from_system():
			#current_arbeitszeit_data = e
	
	var width := 45
	
	print("")
	print("")
	print("-----------------------------------------------")
	
	print(center_text("Bäckerei Kasprovicz", width + 2))
	print(center_text("Tel: 08153 / 9527091", width + 2))
	print(center_text("Zum Kuckuksheim 3", width + 2))
	print(center_text("Wörthsee 82237", width + 2))
	
	print("")
	print("- - - - - - - - - - - - - - - - - - - - - - - -")
	print("")

	print(center_text(user.username, width + 2))
	print(format_line("Arbeitszeit:", format_time(current_arbeitszeit_data.time), width + 2))

	
	print("")
	print("-----------------------------------------------")
	print("")

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

func format_time(minutes_float: float) -> String:
	var hours = int(minutes_float / 60)
	var minutes = int(minutes_float) % 60
	
	return "%d:%02d h" % [hours, minutes]

#---------------------------------------------------------------------------------------------------

func get_todays_arbeitszeit_data():
	for e in user.arbeitszeit_datas:
		if e.date == Time.get_date_dict_from_system():
			return e
	return null
