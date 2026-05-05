extends Node

var date
var users
var rechnungsliste : Array[rechnungsliste_element] = []

var customer_count_total : int
var customer_count_ec : int
var customer_count_bar : int
var customer_count_bar_offline : int

var revenue_total : float = 0.0
var revenue_ec : float = 0.0
var revenue_bar : float = 0.0
var revenue_bar_offline : float = 0.0


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _ready() -> void:
	date =  Time.get_date_dict_from_system()


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------
