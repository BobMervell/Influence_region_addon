@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("InfluenceRegion","Node",preload("res://addons/Influence_region/Influence_region.gd"),
		preload("res://addons/Influence_region/Region_icon.png"))


func _exit_tree() -> void:
	remove_custom_type("InfluenceRegion")
