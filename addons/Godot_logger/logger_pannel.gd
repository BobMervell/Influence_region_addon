@tool
extends Control
class_name LoggerPanel

var config = ConfigFile.new()

@onready var trace_check_box: CheckBox = $VBoxContainer/HSplitContainer/VBoxContainer/TraceLog/CheckBox
@onready var info_check_box: CheckBox = $VBoxContainer/HSplitContainer/VBoxContainer/InfoLog/CheckBox
@onready var debug_check_box: CheckBox = $VBoxContainer/HSplitContainer/VBoxContainer/DebugLog/CheckBox
@onready var warn_check_box: CheckBox = $VBoxContainer/HSplitContainer/VBoxContainer/WarnLog/CheckBox
@onready var error_check_box: CheckBox = $VBoxContainer/HSplitContainer/VBoxContainer/ErrorLog/CheckBox
@onready var fatal_check_box: CheckBox = $VBoxContainer/HSplitContainer/VBoxContainer/FatalLog/CheckBox

func _ready() -> void:
	var err = config.load("res://addons/Godot_logger/log_settings.cfg")
	if err != OK:
		return
	trace_check_box.set_pressed_no_signal(config.get_value("LogSettings","log_trace",true))
	info_check_box.set_pressed_no_signal(config.get_value("LogSettings","log_info",true))
	debug_check_box.set_pressed_no_signal(config.get_value("LogSettings","log_debug",true))
	warn_check_box.set_pressed_no_signal(config.get_value("LogSettings","log_warn",true))
	error_check_box.set_pressed_no_signal(config.get_value("LogSettings","log_error",true))
	fatal_check_box.set_pressed_no_signal(config.get_value("LogSettings","log_fatal",true))

func _on_trace_check_box_toggled(toggled_on:bool) -> void:
	pass
	config.set_value("LogSettings","log_trace",toggled_on)
	config.save("res://addons/Godot_logger/log_settings.cfg")

func _on_info_check_box_toggled(toggled_on:bool) -> void:
	pass
	config.set_value("LogSettings","log_info",toggled_on)
	config.save("res://addons/Godot_logger/log_settings.cfg")

func _on_debug_check_box_toggled(toggled_on:bool) -> void:
	pass
	config.set_value("LogSettings","log_debug",toggled_on)
	config.save("res://addons/Godot_logger/log_settings.cfg")

func _on_warn_check_box_toggled(toggled_on:bool) -> void:
	pass
	config.set_value("LogSettings","log_warn",toggled_on)
	config.save("res://addons/Godot_logger/log_settings.cfg")

func _on_error_check_box_toggled(toggled_on:bool) -> void:
	pass
	config.set_value("LogSettings","log_error",toggled_on)
	config.save("res://addons/Godot_logger/log_settings.cfg")

func _on_fatal_check_box_toggled(toggled_on:bool) -> void:
	pass
	config.set_value("LogSettings","log_fatal",toggled_on)
	config.save("res://addons/Godot_logger/log_settings.cfg")

