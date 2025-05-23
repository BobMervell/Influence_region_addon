@tool
extends Resource
class_name BaseRegion

signal on_parameter_updated()
enum SolverType {Sequential,Binary} 
enum MagnitudeVariation {Constant,Ascending,Descending}

@export var sub_regions_distribution:Curve = _create_default_curve():
	set(new_value):
		sub_regions_distribution = new_value
		sub_regions_distribution.changed.connect(func() -> void: on_parameter_updated.emit() )
		on_parameter_updated.emit()
func _create_default_curve() -> Curve:
	var curve:Curve = Curve.new()
	curve.add_point(Vector2.ZERO,Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR)
	curve.add_point(Vector2.ONE, Curve.TANGENT_LINEAR)
	curve.changed.connect(func() -> void: on_parameter_updated.emit() )
	return curve

@export_range(.1,100) var detection_height:float=1.

## List of list list of thw points in each side of the polygon
var polygon_array:Array[Array]
## List of the extremums of each sub region
var mesh_extremums:Array[Dictionary]
## Extremum of all the regions combined
var total_extremums:Dictionary[String,float] = {
		"max_x": -INF, "min_x": +INF,
		"max_z": -INF, "min_z": +INF,
	}

## Template function overriden by every child, returns a list with every shape to draw
func get_meshs(_center:Vector3, _nbr_regions:int,_start_offset:Vector2,
		_magnitude_variation:int) -> Array[MeshInstance3D]:
	return []

## Updates the extemums of current mesh and the total region
func update_extremum(mesh_indx:int,pos:Vector3) -> void:
	if total_extremums.is_empty():
		total_extremums = {
		"max_x": -INF, "min_x": +INF,
		"max_z": -INF, "min_z": +INF,
	}
	mesh_extremums[mesh_indx]["max_x"] = max(mesh_extremums[mesh_indx]["max_x"],pos.x)
	mesh_extremums[mesh_indx]["min_x"] = min(mesh_extremums[mesh_indx]["min_x"],pos.x)
	mesh_extremums[mesh_indx]["max_z"] = max(mesh_extremums[mesh_indx]["max_z"],pos.z)
	mesh_extremums[mesh_indx]["min_z"] = min(mesh_extremums[mesh_indx]["min_z"],pos.z)
	total_extremums["max_x"] = max(total_extremums["max_x"],pos.x)
	total_extremums["min_x"] = min(total_extremums["min_x"],pos.x)
	total_extremums["max_z"] = max(total_extremums["max_z"],pos.z)
	total_extremums["min_z"] = min(total_extremums["min_z"],pos.z)

## Returns a color between red ans yelllow depending on the value of region_x 
func get_region_color(region_x:float,magnitude_variation:int)-> Color:
	if magnitude_variation == MagnitudeVariation.Constant:
		return Color.RED
	elif magnitude_variation == MagnitudeVariation.Ascending:
		return lerp(Color.YELLOW,Color.RED,region_x)
	elif magnitude_variation == MagnitudeVariation.Descending:
		return lerp(Color.RED,Color.YELLOW,region_x)
	return Color.WHITE

## Returns the positional offset of the current sub_region
func process_start_offset(start_offset:Vector2,x:float,radius:float)->Vector2:
	var offset:Vector2 = start_offset
	x = sub_regions_distribution.sample(x)
	return offset * radius * (1- x)

## Returns the magnitude of the region at the given position (between 0 and 1)
func get_distance_magnitude(solver_type:SolverType,magnitude_variation:MagnitudeVariation,
		center:Vector3,pos:Vector3,nbr_regions:int) -> float:
	if pos.y > center.y + detection_height or pos.y < center.y:
		return 0
	if (pos.x < total_extremums["min_x"] or pos.x > total_extremums["max_x"] or
			pos.z< total_extremums["min_z"] or pos.z > total_extremums["max_z"] ):
		return 0 
	var pos_2D:Vector2 = Vector2(pos.x,pos.z)
	var magnitude:float = find_first_greater_than(solver_type,pos_2D)
	return format_output(magnitude_variation,magnitude,nbr_regions)

## Returns the index of the first shape containing the pos2D
func find_first_greater_than(solver_type:SolverType,pos_2D:Vector2) -> float:
	if solver_type == SolverType.Sequential:
		return sequential_solver(pos_2D)
	if solver_type == SolverType.Binary:
		return binary_solver(pos_2D)
	return polygon_array.size() -1

## Solves each sub-region sequentially
func sequential_solver(pos_2D:Vector2) -> int:
	for i:int in range(polygon_array.size()):
		if is_inside_polygon(pos_2D,i):
			return i
	return polygon_array.size() # final output -> 0

## Solves each sub-region using binary algorithm (dichotomie)
func binary_solver(pos_2D:Vector2) -> float:
	var low: int = 0
	var high: int = polygon_array.size()
	var result: float = polygon_array.size()
	var i:int=0
	while low <= high and i < polygon_array.size():
		i += 1
		@warning_ignore("integer_division")
		var mid: int = (low + high) / 2
		if is_inside_polygon(pos_2D,mid):
			high = mid 
			result = mid 
		else:
			low = mid +1
	return result

## Checks if a position is inside a polygon
func is_inside_polygon(pos_2D:Vector2,polygon_indx:int)-> bool:
	#position outside the polygon box with padding
	var polygon_extrememuns:Dictionary = mesh_extremums[polygon_indx]
	if (pos_2D.x < polygon_extrememuns["min_x"] or pos_2D.x > polygon_extrememuns["max_x"] or
			pos_2D.y< polygon_extrememuns["min_z"] or pos_2D.y > polygon_extrememuns["max_z"] ):
		return false
	@warning_ignore_start("unsafe_call_argument")
	var edge_pos:Vector2 = Vector2( polygon_extrememuns["max_x"] + 1 ,0) 
	var nbr_collisions:int=0
	for sides:Dictionary in polygon_array[polygon_indx]:
		var A:Vector2 = Vector2(sides.A.x,sides.A.z)
		var B:Vector2 = Vector2(sides.B.x,sides.B.z)
		
		if do_vectors_collides(pos_2D,edge_pos,A,B):
			nbr_collisions +=1
	@warning_ignore_restore("unsafe_call_argument")
	if nbr_collisions % 2 == 0:
		return false
	return true

## Checks if to segments cross  
func do_vectors_collides(vec1_A:Vector2,vec1_B:Vector2,
		vec2_A:Vector2,vec2_B:Vector2) -> bool:
	 # get infinite line expression of first segment
	var a1:float = vec1_B.y - vec1_A.y
	var b1:float = vec1_A.x - vec1_B.x
	var c1:float = (vec1_B.x * vec1_A.y) - (vec1_A.x * vec1_B.y)
	
	# get infinite line expression of first segment
	var a2:float = vec2_B.y - vec2_A.y
	var b2:float = vec2_A.x - vec2_B.x
	var c2:float = (vec2_B.x * vec2_A.y) - (vec2_A.x * vec2_B.y)
	
	if is_equal_approx(a1*b2 , a2*b1): return false # Colinear
	
	# solve first line equation with both segments points 
	var p1:float = (a1 * vec2_A.x) + (b1 * vec2_A.y) + c1
	var p2:float = (a1 * vec2_B.x) + (b1 * vec2_B.y) + c1
	
	#if p1 and p2 same sign then they are on the same side of the line thus can't have crossed first line
	if ((p1 > 0 and p2 > 0 ) or (p1 < 0 and p2 < 0 )): return false
	
	# The fact that vector 2 intersected the infinite line 1 above doesn't 
	# mean it also intersects the vector 1. Vector 1 is only a subset of that
	# infinite line 1, so it may have intersected that line before the vector
	# started or after it ended. Thus we need to check the other way around.
	p1 = (a2 * vec1_A.x) + (b2 * vec1_A.y) + c2
	p2 = (a2 * vec1_B.x) + (b2 * vec1_B.y) + c2
	if ((p1 > 0 and p2 > 0 ) or (p1 < 0 and p2 < 0 )): return false
	return true

## format the output amplitude to follow the current MagnitudeVariation mode
func format_output(magnitude_variation:MagnitudeVariation,magnitude:float,nbr_regions:int) -> float:
	if magnitude_variation == MagnitudeVariation.Constant:
		magnitude = (magnitude+.1)/float(nbr_regions)
		if magnitude >= 1: return 0
		return ceil(magnitude)
	elif magnitude_variation == MagnitudeVariation.Ascending:
		magnitude = (magnitude+1)/float(nbr_regions)
		if magnitude > 1: return 0
		return magnitude
	elif magnitude_variation == MagnitudeVariation.Descending:
		magnitude = nbr_regions - magnitude
		return magnitude/float(nbr_regions)
	return 0

## Draw a multiple lines
func draw_multi_line(position_list:Array[Vector3], color:Color=Color.WHITE, shadow_on:bool=false) -> MeshInstance3D:
	var mesh_instance:MeshInstance3D= MeshInstance3D.new()
	var immediate_mesh:ImmediateMesh= ImmediateMesh.new()
	var material:ORMMaterial3D= ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	if shadow_on: mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	else: mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(position_list[0])
	for i:int in range(1,position_list.size()-1):
		immediate_mesh.surface_add_vertex(position_list[i])
		immediate_mesh.surface_add_vertex(position_list[i])
	immediate_mesh.surface_add_vertex(position_list[-1])
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	return mesh_instance

##DEPRECATED
## (only used for developpement debugging )
func get_extremum_meshs(center:Vector3) -> Array[MeshInstance3D]:
	var meshs:Array[MeshInstance3D]
	@warning_ignore_start("unsafe_call_argument")
	for ext:Dictionary in mesh_extremums:
		var arr:Array[Vector3] = [
			Vector3(ext.max_x,center.y,ext.max_z),
			Vector3(ext.max_x,center.y,ext.min_z),
			Vector3(ext.min_x,center.y,ext.min_z),
			Vector3(ext.min_x,center.y,ext.max_z),
			Vector3(ext.max_x,center.y,ext.max_z)
		]
		meshs.append(draw_multi_line(arr,Color.RED))
	@warning_ignore_restore("unsafe_call_argument")
	return meshs
