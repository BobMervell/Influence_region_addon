@tool
extends Node
class_name InfluenceRegion

@export var draw_region:bool = true:
	set(new_value):
		draw_region = new_value
		_draw_perimeter()

## Solver used for magnitude processing.
##[br][b]Note:[/b] Binary is faster than sequential
## but doesn't work if sub-regions overlaps each-others.
@export var solver_type: BaseRegion.SolverType = BaseRegion.SolverType.Sequential

## The way the magnitude varies when the position get's further away from the center
@export var magnitude_variation:BaseRegion.MagnitudeVariation = BaseRegion.MagnitudeVariation.Constant:
	set(new_value):
		magnitude_variation = new_value
		_draw_perimeter()

## The different shapes available.
## [br][b]Note:[/b] BaseRegion is not to be directly used it is a base class for the different shapes
@export var region_shape:BaseRegion:
	set(new_value):
		region_shape = new_value
		region_shape.on_parameter_updated.connect(_draw_perimeter)
		_draw_perimeter()

@export_range(1,100)var nbr_regions:int:
	set(new_value):
		nbr_regions = new_value
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

@export_range(-1,1,.001,"or_greater","or_less") var start_offset_x:float = 0:
	set(new_value):
		start_offset_x = new_value
		start_offset.x = start_offset_x
		_draw_perimeter()

@export_range(-1,1,.001,"or_greater","or_less") var start_offset_z:float = 0:
	set(new_value):
		start_offset_z = new_value
		start_offset.y = start_offset_z
		_draw_perimeter()

var start_offset:Vector2=Vector2.ZERO
var region_position_3D:Vector3 = Vector3.ZERO
var line_childs:Array[MeshInstance3D]

func _draw_perimeter()-> void:
	if not region_shape: return
	for child:MeshInstance3D in line_childs:
		remove_child(child)
	line_childs.clear()
	if draw_region:
		for elt:MeshInstance3D in region_shape.get_meshs(region_position_3D,nbr_regions,
				start_offset,magnitude_variation):
			add_child(elt)
			line_childs.append(elt)
	## DEPRECATED 
	## (only used for developpement debugging )
	#for elt in region_shape.get_extremum_meshs(region_position_3D):
		#add_child(elt)

func get_distance_magnitude(pos:Vector3) -> float:
	return region_shape.get_distance_magnitude(solver_type,magnitude_variation,
			region_position_3D,pos,nbr_regions)
