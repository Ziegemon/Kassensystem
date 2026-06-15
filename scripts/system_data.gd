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

var history :  Array[System_data_day_element] = []


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func _ready() -> void:
	date =  Time.get_date_dict_from_system()


#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------


func tagesabschluss() -> void:
	var day_data = System_data_day_element.new()

	day_data.date = Time.get_date_dict_from_system()
	day_data.customer_count_total = customer_count_total
	day_data.customer_count_ec = customer_count_ec
	day_data.customer_count_bar = customer_count_bar
	day_data.customer_count_bar_offline = customer_count_bar_offline

	day_data.revenue_total = revenue_total
	day_data.revenue_ec = revenue_ec
	day_data.revenue_bar = revenue_bar
	day_data.revenue_bar_offline = revenue_bar_offline

	history.append(day_data)
