@tool
extends Node

var config:ConfigFile = ConfigFile.new()

func _ready() -> void:
	var err:Error = config.load("res://addons/Godot_logger/log_settings.cfg")
	if err != OK:
		return

func log_trace(log_message: String, log_details: Dictionary = {}) -> void:
	if config.get_value("LogSettings","log_info",true):
		var error_type:String = "[b]TRACE:[/b] "
		var output_text:String = format_log(log_message,log_details)

		print_rich(error_type + output_text)

func log_info(log_message: String, log_details: Dictionary = {}) -> void:
	if config.get_value("LogSettings","log_info",true):
		var error_type:String = "[b]INFO:[/b] "
		var output_text:String = format_log(log_message,log_details)

		print_rich(error_type + output_text)

func log_debug(log_message: String, log_details: Dictionary = {}) -> void:
	if config.get_value("LogSettings","log_debug",true):
		var error_type:String = "[b][color=#3178C7]DEBUG:[/color][/b] "
		var output_text:String = format_log(log_message,log_details)

		print_rich(error_type + output_text)

func log_warn(log_message: String, log_details: Dictionary = {}) -> void:
	if config.get_value("LogSettings","log_warn",true):
		var error_type:String = "[b][color=#FCDD52]WARNING:[/color][/b] "
		var output_text:String = format_log(log_message,log_details)

		push_warning(output_text)
		print_rich(error_type + output_text)

func log_error(log_message: String, log_details: Dictionary = {}) -> void:
	if config.get_value("LogSettings","log_error",true):
		var error_type:String = "[b][color=#F5693D]ERROR:[/color][/b] "
		var output_text:String = format_log(log_message,log_details)

		push_error(output_text)
		print_rich(error_type + output_text)

func log_fatal(log_message: String, log_details: Dictionary = {}) -> void:
	if config.get_value("LogSettings","log_fatal",true):
		var error_type:String = "[b][color=#CB3D3D]FATAL:[/color][/b] "
		var output_text:String = format_log(log_message,log_details)

		push_error(output_text)
		print_rich(error_type + output_text)

func format_log(log_message: String, log_details: Dictionary = {}) -> String:
	var log_entry:Dictionary = {
		"Message": log_message,
		"Timestamp": Time.get_ticks_msec(),
		"Details": "",
	}
	if not log_details.is_empty():
		log_entry["Details"] = log_details
	return JSON.stringify(log_entry, "...",false)
