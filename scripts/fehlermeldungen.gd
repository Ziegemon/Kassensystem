extends Control

#var text : String
@onready var fehlermeledung_label : Label = $Fehlermeldung_Label

#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------

func pushError(fehlermeldungstext : String):
	fehlermeledung_label.text = fehlermeldungstext
	show()

#---------------------------------------------------------------------------------------------------

func _on_button_pressed() -> void:
	hide()
