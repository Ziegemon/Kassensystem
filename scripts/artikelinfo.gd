extends Control

@onready var artikelinfo_label : Label = $Artikelinfo_Label

@onready var Main = get_tree().root.get_node("Main")


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func pushArtikelinfo(artikelinfo_text : String):
	artikelinfo_label.text = artikelinfo_text
	Main.artikelinfo_button_on.show()
	show()

#---------------------------------------------------------------------------------------------------

func _on_button_pressed() -> void:
	Main.end_artikelinfo()
