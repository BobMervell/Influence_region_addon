@tool
extends Node
@onready var marker_3d: Marker3D = $Marker3D

@export var draw_region:bool = true:
	set(new_value):
		draw_region = new_value
		_draw_perimeter()

@export var region_shape:BaseRegion:
	set(new_value):
		region_shape = new_value
		region_shape.on_parameter_updated.connect(_draw_perimeter)
		_draw_perimeter()

@export_range(0,10) var nbr_sub_regions:int:
	set(new_value):
		nbr_sub_regions = new_value
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


var region_position_3D:Vector3 = Vector3.ZERO

func _draw_perimeter()-> void:
	if not draw_region or not region_shape: return
	for child in get_children():
		if child != marker_3d : remove_child(child)
	if region_shape is CircleRegion:
		for elt in region_shape.get_meshs(region_position_3D,nbr_sub_regions):
			add_child(elt)

func _physics_process(delta: float) -> void:
	if not region_shape:return
	var x = region_shape.get_distance_magnitude(region_position_3D,marker_3d.position,nbr_sub_regions)
