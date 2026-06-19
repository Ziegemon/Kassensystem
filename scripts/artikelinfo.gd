extends Control

@onready var artikelinfo_label : Label = $Artikelinfo_Label

@onready var MAIN = get_tree().root.get_node("MAIN")


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func pushArtikelinfo(artikelinfo_text : String):
	artikelinfo_label.text = artikelinfo_text
	MAIN.artikelinfo_button_on.show()
	show()

#---------------------------------------------------------------------------------------------------

func _on_button_pressed() -> void:
	MAIN.end_artikelinfo()
