@tool
extends EditorPlugin

var dock:LoggerPanel
const PANNEL_UI:PackedScene = preload("res://addons/Godot_logger/logger_pannel.tscn")
const LOGGER_AUTOLOAD = "Logger"

func _enter_tree() -> void:
	dock = PANNEL_UI.instantiate()
	add_control_to_bottom_panel(dock,"Logger")

func _exit_tree() -> void:
	remove_control_from_bottom_panel(dock)
	dock.free()

func _enable_plugin():
	add_autoload_singleton(LOGGER_AUTOLOAD, "res://addons/Godot_logger/logger_autoload.gd")

func _disable_plugin():
	remove_autoload_singleton(LOGGER_AUTOLOAD)

