extends Resource
class_name arbeitszeit_data

var date = Time.get_date_dict_from_system()
var time : float = 0 #in minutes

func _init(_date : Dictionary) -> void:
	date = _date
