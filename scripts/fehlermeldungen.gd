extends Control

#var text : String
@onready var fehlermeledung_label : Label = $Fehlermeldungen/Fehlermeldung_Label

#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------

func pushError(fehlermeldungstext : String):
	fehlermeledung_label.text = fehlermeldungstext
	show()
