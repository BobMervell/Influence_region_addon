@tool
extends Node

@export var region_shape:BaseRegion:
	set(new_value):
		region_shape = new_value
		region_shape.on_parameter_updated.connect(_draw_perimeter)
		_draw_perimeter()

@export_range(0,10) var number_of_sub_regions:int:
	set(new_value):
		number_of_sub_regions = new_value
		_draw_perimeter()

@export var region_position:Vector2 = Vector2.ZERO:
	set(new_value):
		region_position = new_value
		region_position_3D = Vector3(region_position.x,region_position_y,region_position.y)
		_draw_perimeter()
		
##Ignored in 2D
@export var region_position_y:float = 0.:
	set(new_value):
		region_position_y = new_value
		region_position_3D = Vector3(region_position.x,region_position_y,region_position.y)
		_draw_perimeter()

##Ignored in 2D
@export var region_height:float = 0.
var region_position_3D:Vector3 = Vector3.ZERO

func _draw_perimeter()-> void:
	for child in get_children():
		remove_child(child)
	if region_shape is CircleRegion:
		for elt in region_shape.get_meshs(region_position_3D,number_of_sub_regions):
			add_child(elt)
