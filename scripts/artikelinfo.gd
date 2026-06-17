extends Control

@onready var artikelinfo_label : Label = $Artikelinfo_Label


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func pushArtikelinfo(artikelinfo_text : String):
	artikelinfo_label.text = artikelinfo_text
	show()
