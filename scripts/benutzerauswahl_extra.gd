extends Benutzerauswahl_raw
class_name Benutzerauswahl_extra

var user : String = "Extra"

#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _ready() -> void:
	background.color = basic_button_color

#---------------------------------------------------------------------------------------------------

#func _process(delta: float) -> void:
#	pass


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------

func printLastRechnung():
	var this_users_rechnungen : Array[rechnungsliste_element] = []
	
	for e in SystemData.rechnungsliste:
		if e.user_id == 0:
			this_users_rechnungen.append(e)
	
	if this_users_rechnungen.size() > 0:
		printRechnungFromRechnungslisteElement(this_users_rechnungen[this_users_rechnungen.size() - 1])

#---------------------------------------------------------------------------------------------------

func is_benutzerauswahl_extra() -> bool:
	return true
