extends Resource
class_name rechnungsliste_element

var user_name : String #bediener
var user_id : int #0 = user_id of EXTRA user
var item_list_array : Array[item_data_list_element]
var revenue : float
var rabatt
var time
var payment_method : int


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _init(_user_name : String, _user_id : int, _item_list_array : Array[item_data_list_element], _revenue : float, _rabatt : float, _payment_method : int) -> void:
	user_name = _user_name
	user_id = _user_id
	item_list_array = _item_list_array
	revenue = _revenue
	rabatt = _rabatt
	time = Time.get_time_dict_from_system()
	payment_method = _payment_method
