extends Resource
class_name rechnungsliste_element

var user : user_data #bediener
var revenue : float
var time
var payment_method : int


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _init(_user : user_data, _revenue : float, _payment_method : int) -> void:
	user = _user
	revenue = _revenue
	time = Time.get_time_dict_from_system()
	payment_method = _payment_method
