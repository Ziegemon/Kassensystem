extends Resource
class_name item_data

@export_category("Infos")
@export var name : String
@export var description : String = ("xx% Weizenmehl \n" + "xx% Dinkelmehl \n" + "Sonnenblumenkerne")

@export_category("Daten")
@export var price : float
@export var wiegeprodukt : bool
@export var item_id : int

#id 0- 29: helle Semmeln
#id 29 - 49: Laugenzeug
#id 50 - 69: Dinkelsemmeln
#id 70 - 89: Körnersemmeln
#id 90 - 99: Kaffee
#id 100 - 129: Plunder
#id 130 - 139: Aktion
#id 140 - 159: Dauergebäck
